extends CollisionShape2D

func _on_killzone_second_puzzle_2_body_exited(body: Node2D) -> void:
	if body.has_method("player") and !GlobalVars.player_in_past :
		#player dies
		Dialogic.start_timeline("DieInRiver")
