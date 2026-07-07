extends Node

@onready var main_menu = $UI/MainMenu
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var present_root: Node2D = $PresentRoot
@onready var past_root: Node2D = $PastRoot
@onready var menu: CanvasLayer = $UI/Control
@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var control: CanvasLayer = $Control
@onready var h_slider: HSlider = $Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider
@onready var h_slider_2: HSlider = $Settings/AspectRatioContainer/VBoxContainer/AspectRatioContainer/GridContainer/HSlider2
@onready var game_over: CanvasLayer = $UI/GameOver
@onready var inventory_overlay: CanvasLayer = $UI/InventoryOverlay
@onready var game_won: CanvasLayer = $UI/GameWon

@onready var timeobjectManager: TimeobjectManager = TimeobjectManager.new()

var playerPS: PackedScene = preload("res://Scenes/Game-Elements/Player.tscn")
var player: CharacterBody2D = null

func _ready() -> void:
	game_won.visible = false
	GlobalVars.player_in_past = false
	print("past_root: ", past_root)
	print("present_root: ", present_root)
	print("main_menu: ", main_menu)
	Dialogic.signal_event.connect(game_lost)
	GlobalVars.winning_condition.connect(player_won)

func _process(delta: float) -> void:
		if Input.is_action_just_pressed("esc"):
			if main_menu.visible:
				get_tree().quit()
			else:
				show_menu()
		#if Input.is_action_just_pressed("inventory"):
		#	inventory_overlay.visible =!inventory_overlay.visible

func toggle_time() -> void:
	GlobalVars.player_in_past = !GlobalVars.player_in_past
	Dialogic.VAR.in_past = GlobalVars.player_in_past
	print("Is in past: " + str(GlobalVars.player_in_past))

func start_game():
	GlobalVars.player_won = false
	Dialogic.VAR.playing = true
	timeobjectManager.initializeTimeobjects(get_tree())
	main_menu.visible = false
	game_over.visible = false
	game_won.visible = false
	if player== null:
		player =  playerPS.instantiate()
	add_child(player)
	player.global_position.x = 600
	player.global_position.y = -10400
	inventory_overlay.visible = true
	player.find_child("Camera2D").make_current()
	Dialogic.start("timeline")

func show_menu():	
	game_over.visible = false
	button_click.play()
	GlobalVars.esc_pressed.emit()
	menu.visible = !menu.visible

func game_lost(argument):
	if argument == "player_lost":
		game_over.visible = true

func player_won():
	game_won.visible = true
