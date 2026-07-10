class_name PlayerTimetravelComponent extends PlayerComponent
var player: PlayerCharacterBody2D

func _init(player: PlayerCharacterBody2D) -> void:
	super(player)
	self.player = player

func processInput(delta: float) -> void:
	if Input.is_action_just_pressed("timetravel"):
		var targetLocation: Vector2 = Vector2(player.global_position.x, ((player.global_position.y-20001) if (GlobalVars.player_in_past) else (player.global_position.y+19999)))
		print(targetLocation)
		if isTeleportAllowed(targetLocation):
			player.get_tree().current_scene.toggle_time()
			player.global_position.y = (targetLocation.y - player.TELEPORT_BUFFER)
			player.playerMovement.changeState("FallingMotionState") ## Attempted Fix for timetravel while on ladder

func isTeleportAllowed(tgtLoc: Vector2) -> bool: ## Attempted Fix for timetravel into solid objects
	var spaceState = player.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = player.find_child("CollisionShape2D").shape 
	query.transform = Transform2D(0, tgtLoc)
	query.collision_mask = player.collision_mask
	
	return spaceState.intersect_shape(query).size() == 0
