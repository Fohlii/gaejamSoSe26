extends Node

@onready var main_menu: Node2D = $UI/MainMenu
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var present_root: Node2D = $PresentRoot
@onready var past_root: Node2D = $PastRoot
@onready var menu: CanvasLayer = $UI/Control
@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var control: CanvasLayer = $Control
@onready var h_slider: HSlider = $Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider
@onready var h_slider_2: HSlider = $Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider2

@onready var timeobjectManager: TimeobjectManager = TimeobjectManager.new()

var playerPS: PackedScene = preload("res://Scenes/Game-Elements/Player.tscn")
var player: CharacterBody2D

func _ready() -> void:
	GlobalVars.player_in_past = false
	print("past_root: ", past_root)
	print("present_root: ", present_root)
	print("main_menu: ", main_menu)

func _process(delta: float) -> void:
		if Input.is_action_just_pressed("esc"):
			if main_menu.visible:
				get_tree().quit()
			else:
				show_menu()

func toggle_time() -> void:
	GlobalVars.player_in_past = !GlobalVars.player_in_past
	Dialogic.VAR.in_past = GlobalVars.player_in_past
	print("Is in past: " + str(GlobalVars.player_in_past))

func start_game():
	timeobjectManager.initializeTimeobjects(get_tree())
	main_menu.visible = false
	player = playerPS.instantiate()
	add_child(player)
	player.global_position.x = 1700
	player.global_position.y = -10550
	player.find_child("Camera2D").make_current()
	Dialogic.start("timeline")

func show_menu():	
	button_click.play()
	GlobalVars.esc_pressed.emit()
	menu.visible = !menu.visible
