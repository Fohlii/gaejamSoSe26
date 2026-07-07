extends Area2D
var first_time = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if first_time && Dialogic.VAR.playing:
		Dialogic.start("River")
		first_time= false
	pass # Replace with function body.
