extends HSlider

@onready var settings= $"/root/GlobalVars"

signal volume_changed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_drag_ended(value_changed: bool) -> void:
	settings.musicVol = value
	volume_changed.emit()


func _on_value_changed(value: float) -> void:
	settings.musicVol = value
	volume_changed.emit()
