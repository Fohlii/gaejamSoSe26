class_name PlayerCharacterBody2D extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var left_foot: AudioStreamPlayer2D = $left_foot
@onready var right_foot: AudioStreamPlayer2D = $right_foot
@onready var interactionArea: Area2D = $InteractionArea
var SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var playerMovement: PlayerMovementComponent = PlayerMovementComponent.new(self)
#@onready var playerTimetravel: PlayerTimetravelComponent = PlayerTimetravelComponent.new(self)
@onready var playerInteraction: PlayerInteractionComponent = PlayerInteractionComponent.new(self)
#@onready var playerAnimation: PlayerAnimationComponent = PlayerAnimationComponent.new(self)

func _ready() -> void:
	playerMovement.changeState("IdleMotionState")

func _physics_process(delta: float) -> void:
	velocity = playerMovement.processInput(delta)
	move_and_slide()

func _process(delta: float) -> void:
	playerInteraction.processInput(interactionArea)

func _on_sprite_2d_frame_changed() -> void:
	if sprite_2d.frame == 2:
		left_foot.play()
	elif sprite_2d.frame == 5:
		right_foot.play()

class PlayerMovementComponent extends RefCounted:
	var playerMotionStates: Dictionary[String, MotionState]
	var currentState: MotionState
	
	func _init(player: PlayerCharacterBody2D) -> void:
		
		playerMotionStates["IdleMotionState"] = MotionState.new(
			func(): 
				print("idleMotionState entered")
				player.sprite_2d.play("default")
				, 
			func(): 
				print("idleMotionState exited")
				, 
			func(delta: float):
				#if Input.get_axis("walk_left", "walk_right") != 0 && Input.is_action_pressed("run"):
				#	changeState("RunningMotionState")
				#	return processInput()
				
				if Input.get_axis("walk_left", "walk_right") != 0:
					changeState("WalkingMotionState")
					return processInput(delta)
					
				if Input.is_action_pressed("jump"):
					changeState("JumpingMotionState")
					return processInput(delta)
				
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return processInput(delta)
				
				#TODO check climbing
				
				return Vector2(move_toward(player.velocity.x, 0, player.SPEED), player.velocity.y)
		)
		
		playerMotionStates["WalkingMotionState"] = MotionState.new(
			func(): 
				print("walkingMotionState entered")
				player.sprite_2d.play("walk")
				, 
			func(): 
				print("walkingMotionState exited")
				, 
			func(delta: float):
				if Input.get_axis("walk_left", "walk_right") == 0:
					changeState("IdleMotionState")
					return processInput(delta)
				
				#if Input.get_axis("walk_left", "walk_right") != 0 && Input.is_action_pressed("run"):
				#	changeState("RunningMotionState")
				#	return processInput()
				
				if Input.is_action_pressed("jump"):
					changeState("JumpingMotionState")
					return processInput(delta)
				
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return processInput(delta)
				
				#TODO check climbing
				
				var direction = Input.get_axis("walk_left", "walk_right")
				player.sprite_2d.flip_h = (direction < 0)
				return Vector2(direction * player.SPEED, player.velocity.y)
		)
		
		playerMotionStates["RunningMotionState"] = MotionState.new(
			func(): print("runningMotionState entered"), 
			func(): print("runningMotionState exited"), 
			func(): #TODO
				print("runningMotionState process input called")
				return player.velocity
		)
		
		playerMotionStates["JumpingMotionState"] = MotionState.new(
			func(): 
				print("jumpingMotionState entered")
				player.sprite_2d.play("jump")
				, 
			func(): 
				print("jumpingMotionState exited")
				, 
			func(delta: float): #TODO
				changeState("FallingMotionState")
				var direction = Input.get_axis("walk_left", "walk_right")
				player.sprite_2d.flip_h = (direction < 0)
				return Vector2(direction * player.SPEED, player.JUMP_VELOCITY)
		)
		
		playerMotionStates["FallingMotionState"] = MotionState.new(
			func(): 
				print("fallingMotionState entered")
				, 
			func(): 
				print("fallingMotionState exited")
				, 
			func(delta: float): #TODO
				if player.is_on_floor():
					changeState("LandingMotionState")
					return processInput(delta)
				
				var direction = Input.get_axis("walk_left", "walk_right")
				if direction != 0:
					player.sprite_2d.flip_h = (direction < 0)
				
				return (player.velocity + (player.get_gravity() * delta))
		)
		
		playerMotionStates["LandingMotionState"] = MotionState.new(
			func(): 
				print("landingMotionState entered")
				, 
			func(): 
				print("landingMotionState exited")
				, 
			func(delta: float): 
				changeState("IdleMotionState")
				return processInput(delta)
		)
		
		playerMotionStates["IdleClimbingMotionState"] = MotionState.new(
			func(): 
				print("idleClimbingMotionState entered")
				, 
			func(): 
				print("idleClimbingMotionState exited")
				, 
			func(delta: float): #TODO
				print("idleClimbingMotionState process input called")
				return player.velocity
		)
		
		playerMotionStates["ClimbingMotionState"] = MotionState.new(
			func(): 
				print("climbingMotionState entered")
				, 
			func(): 
				print("climbingMotionState exited")
				, 
			func(delta: float): #TODO
				print("climbingMotionState process input called")
				return player.velocity
		)
		
		playerMotionStates["TimetravelMotionState"] = MotionState.new(
			func(): 
				print("timetravelMotionState entered")
				, 
			func(): 
				print("timetravelMotionState exited")
				, 
			func(delta: float): #TODO
				if !player.is_on_floor():
					changeState("FallingMotionState")
					return processInput(delta)
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

class PlayerInteractionComponent extends RefCounted:
	var playerInventory: Inventory
	var playerInventoryUI: Node2D
	
	func _init(player: PlayerCharacterBody2D) -> void:
		playerInventory = Inventory.new()
	
	func processInput(interactionZone: Area2D) -> void:
		if Input.is_action_just_pressed("interact"):
			if !interactionZone.get_overlapping_bodies().is_empty(): #.filter(func(node: Node2D) -> bool: return node.is_in_group("interactable"))
				print("player interaction called")
				playerInteract(interactionZone.get_overlapping_bodies()[0]) #arbitrary [0]
	
	func playerInteract(interactable: Interactable):
		if interactable.needsItem() != "":
			if playerInventory.hasItem(interactable.needsItem()):
				# TODO remove item sprite from playerInventoryUI
				playerInventory.removeItem(interactable.needsItem())
				interactable.interactWith(interactable.needsItem())
				if interactable.givesItem() != "":
					# TODO add item sprite to playerInventoryUI
					playerInventory.addItem(interactable.givesItem())
		elif interactable.givesItem() != "":
			interactable.interactWith("")
			# TODO add item sprite to playerInventoryUI
			playerInventory.addItem(interactable.givesItem())
	
	class Inventory extends RefCounted:
		var contents: Array[String]
		
		func addItem(itemId: String) -> void:
			contents.append(itemId)
		
		func removeItem(itemId: String) -> void:
			contents.remove_at(contents.find(itemId))
		
		func hasItem(itemId: String) -> bool:
			return contents.has(itemId)
