class_name PlayerTimetravelComponent extends PlayerComponent
var player: PlayerCharacterBody2D

func _init(player: PlayerCharacterBody2D) -> void:
	super(player)
	self.player = player

func processInput(delta: float) -> void:
	if Input.is_action_just_pressed("timetravel"):
		player.get_tree().current_scene.toggle_time()
		player.global_position.y += ((20000-player.TELEPORT_BUFFER) if (GlobalVars.player_in_past) else (-20000-player.TELEPORT_BUFFER))
		player.playerMovement.changeState("FallingMotionState") ## Attempted Fix for timetravel while on ladder
