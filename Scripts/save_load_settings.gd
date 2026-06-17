extends Node

func _save_settings():
	var cfg = ConfigFile.new()
	cfg.set_value("audio",
	"master_volume", GlobalVars.musicVol)
	print(GlobalVars.musicVol)
	cfg.set_value("audio", "sfx_volume",
	GlobalVars.sfxVol)
	cfg.save("user://settings.cfg")
	print(GlobalVars.sfxVol)
	
func _load_settings():
	var cfg = ConfigFile.new()
	var err = cfg.load("user://settings.cfg")
	if err == OK:
		var vol = cfg.get_value(
		"audio",
		"master_volume",
		1.0) # Default-Wert
		print("Geladen: " + str(vol))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol*0.1)
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol*0.1)
		GlobalVars.musicVol = vol
		var sfxVol = cfg.get_value(
		"audio",
		"sfx_volume",
		1.0) # Default-Wert
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfxVol*0.1)
		GlobalVars.sfxVol = sfxVol
		print("Geladen: " + str(sfxVol))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
