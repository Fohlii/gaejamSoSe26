extends Node

func _on_first_puzzle_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Dialogic.start("WaterRising")
	pass # Replace with function body.

func _on_second_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Dialogic.start("River")
	pass


func _on_third_puzzle_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Dialogic.start("Cave")
	pass # Replace with function body.
