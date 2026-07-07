extends Node

@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var how_to_play: HBoxContainer = $HowToPlay
@onready var settings: HBoxContainer = $Settings
@onready var main_menu: HBoxContainer = $MainMenu
@onready var game_settings= $"/root/GlobalVars"
@onready var master_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")
@onready var control: CanvasLayer = $".."
@onready var exit: ConfirmationDialog = $ConfirmationDialog
@onready var dark_overlay: ColorRect = $"../DarkOverlay"

func _ready() -> void:
	GlobalVars.connect( "esc_pressed",_on_esc_pressed)

func changeVol() -> void:
	#musicplayer.volume_db = -80 + (15*pow(settings.musicVol,0.37))
	AudioServer.set_bus_volume_db(master_bus_index,-80 + (15*pow(game_settings.musicVol,0.37)))
	SaveLoadSettings._save_settings()
func changeSfxVol() -> void:
	#musicplayer.volume_db = -80 + (15*pow(settings.musicVol,0.37))
	AudioServer.set_bus_volume_db(sfx_bus_index,-80 + (15*pow(game_settings.sfxVol,0.37)))
	SaveLoadSettings._save_settings()
func play_click_sound() -> void:
	button_click.play()
	await button_click.finished

func _on_esc_pressed():
	_on_button_3_pressed()

func _on_play_button_pressed() -> void:
	await play_click_sound()
	control.visible = false

func _on_settings_button_pressed() -> void:
	await play_click_sound()
	## get_tree().change_scene_to_file("res://Scenes/UI-Elements/Settings.tscn")
	settings.visible = false
	main_menu.visible = false
	how_to_play.visible = true

func _on_how_to_play_button_pressed() -> void:
	await play_click_sound()
	settings.visible = true
	main_menu.visible = false
	how_to_play.visible = false

func _on_button_3_pressed() -> void:
	await play_click_sound()
	settings.visible = false
	main_menu.visible = true
	how_to_play.visible = false

func _on_exit_button_pressed() -> void:
	play_click_sound()
	exit.popup_centered(Vector2i(300, 150))
	main_menu.visible = false
	
func _on_confirmation_dialog_confirmed() -> void:
	play_click_sound()
	get_tree().quit()

func _on_confirmation_dialog_canceled() -> void:
	play_click_sound()
	exit.hide()
	main_menu.visible = true
