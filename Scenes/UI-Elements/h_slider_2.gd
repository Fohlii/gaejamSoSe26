extends HSlider
signal sfx_volume_changed

func _on_value_changed(value: float) -> void:
	GlobalVars.sfxVol = value
	sfx_volume_changed.emit()
