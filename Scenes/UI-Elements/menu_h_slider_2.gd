extends HSlider
@onready var settings= $"/root/GlobalVars"
signal sfx_volume_changed

func _ready():
	self.value = settings.sfxVol
	
func _on_value_changed(value: float) -> void:
	settings.sfxVol = value
	sfx_volume_changed.emit()
