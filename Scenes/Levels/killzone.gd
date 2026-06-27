extends CollisionPolygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_killzone_first_puuzzle_body_entered(body: Node2D) -> void:
		if body.has_method("player") and !GlobalVars.player_in_past :
		#player dies
			Dialogic.start_timeline("DieInWater")
