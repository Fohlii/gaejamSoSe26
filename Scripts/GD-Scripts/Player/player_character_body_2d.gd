class_name PlayerCharacterBody2D extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var left_foot: AudioStreamPlayer2D = $left_foot
@onready var right_foot: AudioStreamPlayer2D = $right_foot
var SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var playerMovement: PlayerMovementComponent = PlayerMovementComponent.new(self)
#@onready var playerTimetravel: PlayerTimetravelComponent = PlayerTimetravelComponent.new(self)
#@onready var playerInteraction: PlayerInteractionComponent = PlayerInteractionComponent.new(self)
#@onready var playerAnimation: PlayerAnimationComponent = PlayerAnimationComponent.new(self)

func _ready() -> void:
	playerMovement.changeState("IdleMotionState")

func _physics_process(delta: float) -> void:
	velocity = playerMovement.processInput()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprite_2d.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("walk_left", "walk_right")
	#if direction:
	#	if Input.is_action_pressed("run"):
	#		SPEED = 400.0
	#	else:
	#		SPEED = 200.0
	#	if sprite_2d.animation != "walk":
	#		sprite_2d.play("walk")
	#	velocity.x = direction * SPEED
	#	if direction < 0:
	#		sprite_2d.flip_h = true
	#	else:
	#		sprite_2d.flip_h= false
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#	sprite_2d.play("default")
	
	move_and_slide()

func _on_sprite_2d_frame_changed() -> void:
	if sprite_2d.frame == 2:
		left_foot.play()
	elif sprite_2d.frame == 5:
		right_foot.play()

class PlayerMovementComponent:
	var playerMotionStates: Dictionary[String, MotionState]
	var currentState: MotionState
	
	func _init(player: PlayerCharacterBody2D) -> void:
		var idleMotionState = MotionState.new(
			func(): print("idleMotionState entered"), 
			func(): print("idleMotionState exited"), 
			func(): 
				var direction = Input.get_axis("walk_left", "walk_right")
				if direction == 0:
					return Vector2(0, player.velocity.y)
				
				elif direction != 0:
					changeState("WalkingMotionState")
					return processInput()
		)
		playerMotionStates["IdleMotionState"] = idleMotionState
		var walkingMotionState = MotionState.new(
			func(): print("walkingMotionState entered"), 
			func(): print("walkingMotionState exited"), 
			func(): 
				var direction = Input.get_axis("walk_left", "walk_right")
				if direction != 0:
					return Vector2(direction * player.SPEED, player.velocity.y)
				
				elif direction == 0:
					changeState("IdleMotionState")
					return processInput()
		)
		playerMotionStates["WalkingMotionState"] = walkingMotionState
		var runningMotionState #TODO
		var jumpingMotionState #TODO
		var fallingMotionState #TODO
		var landingMotionState #TODO
		var climbingMotionState #TODO
	
	func changeState(newStateName: String):
		if (currentState):
			currentState.exitState()
		currentState = playerMotionStates[newStateName]
		if (currentState):
			currentState.enterState()
	
	func processInput() -> Vector2:
		return currentState.processInput()
	
	class MotionState:
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
		
		func processInput() -> Vector2:
			return _processInput.call()
