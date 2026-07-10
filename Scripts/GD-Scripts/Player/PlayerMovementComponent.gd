class_name PlayerMovementComponent extends PlayerComponent
var playerMotionStates: Dictionary[String, MotionState]
var currentState: MotionState
# var canClimb: Callable

func _init(player: PlayerCharacterBody2D) -> void:
	super(player)
	# canClimb = player.climbCheckArea.has_overlapping_areas
	
	# TODO: switch to new system (currently named "Experimental) to improve readability.
	
	playerMotionStates["Unresponsive"] = MotionState.new(
		func(): 
			if GlobalVars.DEBUG_PLAYERMOVEMENT:
				print("unresponsiveMotionState entered")
			player.sprite_2d.play("default")
			, 
		func(): 
			if GlobalVars.DEBUG_PLAYERMOVEMENT:
				print("unresponsiveMotionState exited")
			, 
		func(delta: float):
			if !player.is_on_floor():
				return (player.velocity + (player.get_gravity() * delta))
			
			return Vector2.ZERO
			,
		func ():
			return
			,
		func (delta: float):
			if !player.is_on_floor():
				return (player.velocity + (player.get_gravity() * delta))
			else:
				return Vector2.ZERO
	)
	
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
			,
		func():
			if !player.is_on_floor():
				changeState("FallingMotionState")
			if Input.is_action_pressed("timetravel"):
				pass #TODO
			if Input.get_axis("walk_left", "walk_right") != 0 && Input.is_action_pressed("run"):
				changeState("RunningMotionState")
			if Input.get_axis("walk_left", "walk_right") != 0 && !Input.is_action_pressed("run"):
				changeState("WalkingMotionState")
			if Input.get_axis("climb_down", "climb_up") != 0 && player.climbCheckArea.has_overlapping_areas():
				changeState("ClimbingMotionState")
			if Input.is_action_pressed("jump"):
				changeState("JumpingMotionState")
			,
		func(delta: float):
			return Vector2.ZERO
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
			player.safeSpot = player.global_position
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
			,
		func():
			return
			,
		func(delta: float):
			return Vector2.ZERO
	)
	
	playerMotionStates["RunningMotionState"] = MotionState.new(
		func(): 
			if GlobalVars.DEBUG_PLAYERMOVEMENT:
				print("runningMotionState entered")
			, 
		func(): 
			if GlobalVars.DEBUG_PLAYERMOVEMENT:
				print("runningMotionState exited")
			player.safeSpot = player.global_position
			, 
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
			,
		func():
			return
			,
		func(delta: float):
			return Vector2.ZERO
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
			player.safeSpot = player.global_position
			, 
		func(delta: float):
			changeState("FallingMotionState")
			var direction: float = Input.get_axis("walk_left", "walk_right")
			if direction != 0:
				player.sprite_2d.flip_h = (direction < 0)
				player.interactionArea.rotation = (PI) if (direction < 0) else (0)
			return Vector2(direction * max(abs(player.velocity.x), player.STANDING_JUMP_X), player.JUMP_VELOCITY)
			,
		func():
			return
			,
		func(delta: float):
			return Vector2.ZERO
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
			
			if Input.get_action_strength("climb_up") > 0 && player.climbCheckArea.has_overlapping_areas():
				changeState("ClimbingMotionState")
				return Vector2.ZERO
			
			var direction = Input.get_axis("walk_left", "walk_right")
			if direction != 0:
				player.sprite_2d.flip_h = (direction < 0)
				player.interactionArea.rotation = (PI) if (direction < 0) else (0)
			
			return (player.velocity + (player.get_gravity() * delta))
			,
		func():
			return
			,
		func(delta: float):
			return Vector2.ZERO
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
			,
		func():
			return
			,
		func(delta: float):
			return Vector2.ZERO
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
			
			if player.climbCheckArea.has_overlapping_areas() && (Input.get_axis("climb_down", "climb_up") != 0 || Input.get_axis("walk_left", "walk_right") != 0):
				changeState("ClimbingMotionState")
				return Vector2.ZERO
			
			if Input.is_action_pressed("jump") || !player.climbCheckArea.has_overlapping_areas():
				changeState("FallingMotionState")
				return Vector2.ZERO
			
			return Vector2.ZERO
			,
		func():
			return
			,
		func(delta: float):
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
			
			if Input.is_action_pressed("jump") || !player.climbCheckArea.has_overlapping_areas():
				changeState("FallingMotionState")
				return processInput(delta)
			
			if Input.get_axis("walk_left", "walk_right") == 0 && Input.get_axis("climb_down", "climb_up") == 0:
				changeState("IdleClimbingMotionState")
				return Vector2.ZERO
			
			return Vector2(Input.get_axis("walk_left", "walk_right") * -player.CLIMB_VELOCITY, Input.get_axis("climb_down", "climb_up") * player.CLIMB_VELOCITY)
			,
		func():
			return
			,
		func(delta: float):
			return Vector2(Input.get_axis("walk_left", "walk_right") * -player.CLIMB_VELOCITY, Input.get_axis("climb_down", "climb_up") * player.CLIMB_VELOCITY)
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
			,
		func():
			return
			,
		func(delta: float):
			return Vector2.ZERO
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
	var _calculateState: Callable
	var _calculateMotion: Callable
	
	func _init(enter: Callable, exit: Callable, process: Callable, processState: Callable = func() -> void: return, processMotion: Callable = func(delta: float) -> Vector2: return Vector2.ZERO) -> void:
		_enterState = enter
		_exitState = exit
		_processInput = process
		_calculateState = processState
		_calculateMotion = processMotion
	
	func enterState() -> void:
		return _enterState.call()
	
	func exitState() -> void:
		return _exitState.call()
	
	func processInput(delta: float) -> Vector2:
		return _processInput.call(delta)
	
	func processInputExperimental(delta: float) -> Vector2:
		_calculateState.call() ## this changes that Motion Statemachine state for the next frame
		return _calculateMotion.call(delta) ## but it processes the input for this frame as the 'old' state
		
	
