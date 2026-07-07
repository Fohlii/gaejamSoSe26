class_name PlayerCharacterBody2D extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var left_foot: AudioStreamPlayer2D = $left_foot
@onready var right_foot: AudioStreamPlayer2D = $right_foot
@onready var climbCheckArea: Area2D = $ClimbCheckArea
@onready var interactionArea: Area2D = $InteractionArea
@onready var inventoryUI: Node2D = null

@export var WALK_SPEED = 200.0
@export var RUN_SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var CLIMB_VELOCITY = -40.0
@export var STANDING_JUMP_X = 100.0
@export var TELEPORT_BUFFER = 50

var playerMovement: PlayerMovement
var playerTimetravel: PlayerTimetravel
var playerInteraction: PlayerInteraction
#var playerAnimation: PlayerAnimation

func _ready() -> void:
	playerMovement = PlayerMovement.new(self)
	playerTimetravel = PlayerTimetravel.new(self)
	playerInteraction = PlayerInteraction.new(self)
	#playerAnimation = PlayerAnimation.new(self)
	playerMovement.changeState("IdleMotionState")

func _physics_process(delta: float) -> void:
	playerInteraction.processInput(delta)
	playerTimetravel.processInput(delta)
	velocity = playerMovement.processInput(delta)
	move_and_slide()

func _on_sprite_2d_frame_changed() -> void:
	if sprite_2d.frame == 2:
		left_foot.play()
	elif sprite_2d.frame == 5:
		right_foot.play()

class PlayerMovement extends PlayerComponent:
	var playerMotionStates: Dictionary[String, MotionState]
	var currentState: MotionState
	# var canClimb: Callable
	
	func _init(player: PlayerCharacterBody2D) -> void:
		super(player)
		# canClimb = player.climbCheckArea.has_overlapping_areas
		
		# TODO: check processInput Callables for correctness and impossiblity of infinite recursion
		playerMotionStates["IdleMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("idleMotionState entered")
				player.sprite_2d.play("default")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("idleMotionState exited")
				, 
			func(delta: float):
				if Input.get_axis("walk_left", "walk_right") != 0:
					changeState("WalkingMotionState")
					return processInput(delta)
				
				if Input.get_axis("walk_left", "walk_right") != 0 && Input.is_action_pressed("run"):
					changeState("RunningMotionState")
					return processInput(delta)
				
				if Input.get_axis("climb_down", "climb_up") != 0 && player.climbCheckArea.has_overlapping_areas():
					changeState("ClimbingMotionState")
					return processInput(delta)
				
				if Input.is_action_pressed("jump"):
					changeState("JumpingMotionState")
					return processInput(delta)
				
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return Vector2.ZERO
				
				return Vector2(move_toward(player.velocity.x, 0, player.WALK_SPEED), player.velocity.y)
		)
		
		playerMotionStates["WalkingMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("walkingMotionState entered")
				player.sprite_2d.play("walk")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("walkingMotionState exited")
				, 
			func(delta: float):
				if Input.get_axis("walk_left", "walk_right") == 0:
					changeState("IdleMotionState")
					return processInput(delta)
				
				if Input.get_axis("walk_left", "walk_right") != 0 && Input.is_action_pressed("run"):
					changeState("RunningMotionState")
					return processInput(delta)
				
				if Input.get_axis("climb_down", "climb_up") != 0 && player.climbCheckArea.has_overlapping_areas():
					changeState("ClimbingMotionState")
					return processInput(delta)
				
				if Input.is_action_pressed("jump"):
					changeState("JumpingMotionState")
					return processInput(delta)
				
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return player.velocity
				
				var direction = Input.get_axis("walk_left", "walk_right")
				player.sprite_2d.flip_h = (direction < 0)
				player.interactionArea.rotation = PI if (direction < 0) else 0
				return Vector2(direction * player.WALK_SPEED, player.velocity.y)
		)
		
		playerMotionStates["RunningMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("runningMotionState entered"), 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("runningMotionState exited"), 
			func(delta: float):
				if Input.get_axis("walk_left", "walk_right") == 0:
					changeState("IdleMotionState")
					return processInput(delta)
				
				if Input.get_axis("walk_left", "walk_right") != 0 && !Input.is_action_pressed("run"):
					changeState("WalkingMotionState")
					return processInput(delta)
				
				if Input.get_axis("climb_down", "climb_up") != 0 && player.climbCheckArea.has_overlapping_areas():
					changeState("ClimbingMotionState")
					return processInput(delta)
				
				if Input.is_action_pressed("jump"):
					changeState("JumpingMotionState")
					return processInput(delta)
				
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return player.velocity
				
				var direction = Input.get_axis("walk_left", "walk_right")
				player.sprite_2d.flip_h = (direction < 0)
				player.interactionArea.rotation = PI if (direction < 0) else 0
				return Vector2(direction * player.RUN_SPEED, player.velocity.y)
		)
		
		playerMotionStates["JumpingMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("jumpingMotionState entered")
				player.sprite_2d.play("jump")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("jumpingMotionState exited")
				, 
			func(delta: float):
				changeState("FallingMotionState")
				var direction: float = Input.get_axis("walk_left", "walk_right")
				if direction != 0:
					player.sprite_2d.flip_h = (direction < 0)
					player.interactionArea.rotation = (PI) if (direction < 0) else (0)
				return Vector2(direction * max(abs(player.velocity.x), player.STANDING_JUMP_X), player.JUMP_VELOCITY)
		)
		
		playerMotionStates["FallingMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("fallingMotionState entered")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("fallingMotionState exited")
				, 
			func(delta: float):
				if player.is_on_floor():
					changeState("LandingMotionState")
					return processInput(delta)
				
				if Input.get_axis("climb_down", "climb_up") != 0 && player.climbCheckArea.has_overlapping_areas():
					changeState("ClimbingMotionState")
					return Vector2.ZERO
				
				var direction = Input.get_axis("walk_left", "walk_right")
				if direction != 0:
					player.sprite_2d.flip_h = (direction < 0)
					player.interactionArea.rotation = (PI) if (direction < 0) else (0)
				
				return (player.velocity + (player.get_gravity() * delta))
		)
		
		playerMotionStates["LandingMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("landingMotionState entered")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("landingMotionState exited")
				, 
			func(delta: float): 
				await player.get_tree().create_timer(0.2)
				changeState("IdleMotionState")
				return processInput(delta)
		)
		
		playerMotionStates["IdleClimbingMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("idleClimbingMotionState entered")
				player.sprite_2d.play("default")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("idleClimbingMotionState exited")
				, 
			func(delta: float): #TODO
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("idleClimbingMotionState process input called")
				
				if Input.get_axis("climb_down", "climb_up") != 0 && player.climbCheckArea.has_overlapping_areas():
					changeState("ClimbingMotionState")
					return processInput(delta)
				
				if Input.get_axis("walk_left", "walk_right") != 0 || Input.is_action_pressed("jump"):
					changeState("FallingMotionState")
					return Vector2.ZERO
				
				return Vector2.ZERO
		)
		
		playerMotionStates["ClimbingMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("climbingMotionState entered")
				player.sprite_2d.play("walk")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("climbingMotionState exited")
				, 
			func(delta: float): #TODO
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("climbingMotionState process input called")
				
				if !player.climbCheckArea.has_overlapping_areas():
					changeState("IdleClimbingMotionState")
					return processInput(delta)
				
				if Input.get_axis("climb_down", "climb_up") == 0:
					changeState("IdleClimbingMotionState")
					return processInput(delta)
				
				if Input.get_axis("walk_left", "walk_right") != 0 || Input.is_action_pressed("jump"):
					changeState("FallingMotionState")
					return Vector2.ZERO
				
				return Vector2(0, Input.get_axis("climb_down", "climb_up") * player.CLIMB_VELOCITY)
		)
		
		playerMotionStates["TimetravelMotionState"] = MotionState.new(
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("timetravelMotionState entered")
				, 
			func(): 
				if GlobalVars.DEBUG_PLAYERMOVEMENT:
					print("timetravelMotionState exited")
				, 
			func(delta: float): #TODO
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return player.velocity
				else:
					return player.velocity
		)
	
	func changeState(newStateName: String) -> void:
		if (currentState):
			currentState.exitState()
		currentState = playerMotionStates[newStateName]
		if (currentState):
			currentState.enterState()
	
	func processInput(delta: float) -> Vector2:
		return currentState.processInput(delta)
	
	class MotionState extends RefCounted:
		var _enterState: Callable
		var _exitState: Callable
		var _processInput: Callable
		
		func _init(enter: Callable, exit: Callable, process: Callable) -> void:
			_enterState = enter
			_exitState = exit
			_processInput = process
		
		func enterState() -> void:
			return _enterState.call()
		
		func exitState() -> void:
			return _exitState.call()
		
		func processInput(delta: float) -> Vector2:
			return _processInput.call(delta)

class PlayerTimetravel extends PlayerComponent:
	var player: PlayerCharacterBody2D
	
	func _init(player: PlayerCharacterBody2D) -> void:
		super(player)
		self.player = player
	
	func processInput(delta: float) -> void:
		if Input.is_action_just_pressed("timetravel"):
			player.get_tree().current_scene.toggle_time()
			player.global_position.y += ((20000-player.TELEPORT_BUFFER) if (GlobalVars.player_in_past) else (-20000-player.TELEPORT_BUFFER))
			player.playerMovement.changeState("FallingMotionState") ## Attempted Fix for timetravel while on ladder

class PlayerInteraction extends PlayerComponent:
	var playerInteractionArea: Area2D
	var playerInventoryUI: Node2D
	var playerInventoryItem: Item
	
	func _init(player: PlayerCharacterBody2D) -> void:
		super(player)
		playerInteractionArea = player.interactionArea
		playerInventoryUI = player.inventoryUI
		playerInventoryItem = null
	
	func processInput(delta: float) -> void:
		if Input.is_action_just_pressed("interact"):
			if !playerInteractionArea.get_overlapping_areas().is_empty():
				## Level Design Choice: Interactables should be spread far enough apart to make [0] unambiguous
				_playerInteract(playerInteractionArea.get_overlapping_areas()[0].get_parent())
	
	func _playerInteract(interactable: Interactable):
		playerInventoryItem = interactable.interact(playerInventoryItem)
		# TODO update playerInventoryUI with texture from held item or clear
