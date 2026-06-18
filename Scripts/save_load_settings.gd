extends Node
var cfg = ConfigFile.new()
const SETTINGS_FILE_PATH ="user://settings.cfg"

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		cfg.set_value("audio","master_volume", 100)
		cfg.set_value("audio", "sfx_volume",100)
		cfg.save(SETTINGS_FILE_PATH)

func _save_settings():
	cfg.set_value("audio",
	"master_volume", GlobalVars.musicVol)
	print("saving",GlobalVars.musicVol)
	cfg.set_value("audio", "sfx_volume",
	GlobalVars.sfxVol)
	cfg.save(SETTINGS_FILE_PATH)
	print("saved:",GlobalVars.sfxVol)
	
func _load_settings():
	var err = cfg.load(SETTINGS_FILE_PATH)
	if err == OK:
		var vol = cfg.get_value(
		"audio",
		"master_volume",
		100) # Default-Wert
		print("Geladen master: " + str(vol))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80 + (15*pow(vol,0.37)))
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol*0.1)
		GlobalVars.musicVol = vol
		var sfxVol = cfg.get_value(
		"audio",
		"sfx_volume",
		100)# Default-Wert
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80 + (15*pow(sfxVol,0.37)))
		GlobalVars.sfxVol = sfxVol
		print("Geladen: " + str(sfxVol))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
