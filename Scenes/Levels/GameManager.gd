extends Node2D

@onready var main_menu: Node2D = $MainMenu
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var present_root: Node2D = $PresentRoot
@onready var past_root: Node2D = $PastRoot
@onready var menu: CanvasLayer = $Control
@onready var button_click: AudioStreamPlayer = $ButtonClick

var playerPS: PackedScene = preload("res://Scenes/Game-Elements/Player.tscn")
var player: CharacterBody2D
var in_past := false
func _ready() -> void:	
	print("past_root: ", past_root)
	print("present_root: ", present_root)
	print("main_menu: ", main_menu)
	pass
	
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("timetravel"):
			toggle_time()
		if Input.is_action_just_pressed("esc"):
			show_menu()
func toggle_time() -> void:
	in_past = !in_past
	print("Is in past: " + str(in_past))
	past_root.visible = in_past
	present_root.visible = !in_past
	
func start_game():
	main_menu.visible = false
	player = playerPS.instantiate()
	var playerCam: Camera2D = player.get_child(2)
	player.global_position.y = -500
	add_child(player)
	playerCam.make_current()
	
func show_menu():	
	button_click.play()
	menu.visible = !menu.visible
