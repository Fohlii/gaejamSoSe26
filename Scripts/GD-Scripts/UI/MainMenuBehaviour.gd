extends Node

@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var credits: HBoxContainer = $Credits
@onready var how_to_play: HBoxContainer = $HowToPlay
@onready var settings: HBoxContainer = $Settings
@onready var main_menu: HBoxContainer = $MainMenu
@onready var root_scene = get_tree().get_current_scene()
@onready var present: Node = $"../../PresentRoot"
@onready var playerPS: PackedScene = preload("res://Scenes/Game-Elements/Player.tscn")
@onready var game_settings= $"/root/GlobalVars"
@onready var musicplayer: AudioStreamPlayer = $"../../MusicPlayer"
@onready var master_bus_index = AudioServer.get_bus_index("Master")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("MainMenu")
	game_settings.musicVol = 100	
	game_settings.sfxVol = 100
	musicplayer.playing = true
	var increaseVol:Tween = get_tree().create_tween()
	increaseVol.tween_property(musicplayer,"volume_db",-80 + (15*pow(game_settings.musicVol,0.37)),1).set_trans(Tween.TRANS_QUAD)
	await increaseVol.finished
	increaseVol.kill()
	var increaseSfxVol:Tween = get_tree().create_tween()
	increaseSfxVol.tween_property(musicplayer,"volume_db",-80 + (15*pow(game_settings.sfxVol,0.37)),1).set_trans(Tween.TRANS_QUAD)
	await increaseSfxVol.finished
	increaseSfxVol.kill()
	print("done")
	print(musicplayer.volume_db)
	$Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider.volume_changed.connect(changeVol.bind())
	$Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider2.sfx_volume_changed.connect(changeSfxVol.bind())
	$"../Control/Menu/Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider2".sfx_volume_changed.connect(changeSfxVol.bind())
	$"../Control/Menu/Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider".volume_changed.connect(changeVol.bind())
## 
func changeVol() -> void:
	#musicplayer.volume_db = -80 + (15*pow(settings.musicVol,0.37))
	AudioServer.set_bus_volume_db(master_bus_index,-80 + (15*pow(game_settings.musicVol,0.37)))
func changeSfxVol() -> void:
	#musicplayer.volume_db = -80 + (15*pow(settings.musicVol,0.37))
	AudioServer.set_bus_volume_db(sfx_bus_index,-80 + (15*pow(game_settings.sfxVol,0.37)))
func play_click_sound() -> void:
	button_click.play()
	await button_click.finished

func _on_play_button_pressed() -> void:
	await play_click_sound()
	get_tree().current_scene.start_game()

func _on_settings_button_pressed() -> void:
	await play_click_sound()
	## get_tree().change_scene_to_file("res://Scenes/UI-Elements/Settings.tscn")
	settings.visible = true
	main_menu.visible = false
	how_to_play.visible = false
	credits.visible = false

func _on_how_to_play_button_pressed() -> void:
	await play_click_sound()
	settings.visible = false
	main_menu.visible = false
	how_to_play.visible = true
	credits.visible = false

func _on_credits_button_pressed() -> void:
	await play_click_sound()
	settings.visible = false
	main_menu.visible = false
	how_to_play.visible = false
	credits.visible = true

func _on_button_3_pressed() -> void:
	await play_click_sound()
	settings.visible = false
	main_menu.visible = true
	how_to_play.visible = false
	credits.visible = false

func _on_button_button_down() -> void:
	pass # Replace with function body.


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	
	pass # Replace with function body.
