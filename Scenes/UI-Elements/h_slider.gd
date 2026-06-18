extends HSlider

signal volume_changed

func _on_value_changed(value: float) -> void:
	GlobalVars.musicVol = value
	volume_changed.emit()
