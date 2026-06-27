extends HSlider

@onready var settings= $"/root/GlobalVars"

signal volume_changed
func _ready() -> void:
	self.set_value_no_signal(settings.musicVol)


func _on_value_changed(value: float) -> void:
	settings.musicVol = value
	volume_changed.emit()
