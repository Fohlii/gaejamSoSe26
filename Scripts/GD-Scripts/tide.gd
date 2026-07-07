extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if !Dialogic.VAR.in_past:
		Dialogic.start("DieInWater")
	pass # Replace with function body.
