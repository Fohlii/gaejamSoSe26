extends Node2D

@onready var main_menu: Node2D = $UI/MainMenu
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var present_root: Node2D = $PresentRoot
@onready var past_root: Node2D = $PastRoot
@onready var menu: CanvasLayer = $UI/Control
@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var control: CanvasLayer = $Control

var playerPS: PackedScene = preload("res://Scenes/Game-Elements/Player.tscn")
var player: CharacterBody2D
var in_past := false
func _ready() -> void:	
	print("past_root: ", past_root)
	print("present_root: ", present_root)
	print("main_menu: ", main_menu)
	$PastRoot/Colliders/Objects/placeNearRiver.future_tree = $PresentRoot/Areas/Mountain/BackLayer/Objects/tree.PlantTree
	
func _process(delta: float) -> void: ## Warum wird Playerinput-Timetravel im GameManager behandelt?? -> Weil das Skript am root attached ist 
		if Input.is_action_just_pressed("timetravel"):
			toggle_time()
		if Input.is_action_just_pressed("esc"):
			if main_menu.visible:
				get_tree().quit()
			else:
				show_menu()
func toggle_time() -> void:
	in_past = !in_past
	print("Is in past: " + str(in_past))

	print("past visible: " + str(past_root.visible))
	print("present visible" + str(present_root.visible))
	#Parallax layer müssen einzeln unsichtbar gemacht werden, weil bei regulären Nodes visible nicht gesetzt werden kann
	$PresentRoot/Parallax/FarthestBackgroundLayer.visible = !in_past
	$PastRoot/Parallax/FarthestBackgroundLayer.visible = in_past
func start_game():
	main_menu.visible = false
	player = playerPS.instantiate()
	var playerCam: Camera2D = player.get_child(2)
	player.global_position.x = 1000
	player.global_position.y = -100
	add_child(player)
	#present_root.add_child(player)
	#present_root.get_child(2).camera = playerCam
	playerCam.make_current()
	Dialogic.start("timeline")
	
func show_menu():	
	button_click.play()
	GlobalVars.esc_pressed.emit()
	menu.visible = !menu.visible
