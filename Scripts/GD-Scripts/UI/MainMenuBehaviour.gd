extends Node

@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var credits: HBoxContainer = $Credits
@onready var how_to_play: HBoxContainer = $HowToPlay
@onready var settings: HBoxContainer = $Settings
@onready var main_menu: HBoxContainer = $MainMenu

@onready var present: Node = $"../PresentRoot"
@onready var playerPS: PackedScene = preload("res://Scenes/Game-Elements/Player.tscn")


func play_click_sound() -> void:
	button_click.play()
	await button_click.finished


func _on_play_button_pressed() -> void:
	await play_click_sound()
	var player: CharacterBody2D = playerPS.instantiate()
	var playerCam: Camera2D = player.get_child(2)
	player.position.y = -500
	present.add_child(player)
	playerCam.make_current()
	self.get_parent().remove_child(self)

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
