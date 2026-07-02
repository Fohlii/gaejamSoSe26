extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Dialogic.start_timeline("DieInWater")
	pass # Replace with function body.
