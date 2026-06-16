extends Node

func _on_first_puzzle_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Dialogic.start("WaterRising")
	
	pass # Replace with function body.
