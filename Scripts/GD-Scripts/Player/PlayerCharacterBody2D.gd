class_name PlayerCharacterBody2D extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var left_foot: AudioStreamPlayer2D = $left_foot
@onready var right_foot: AudioStreamPlayer2D = $right_foot
@onready var climbCheckArea: Area2D = $ClimbCheckArea
@onready var interactionArea: Area2D = $InteractionArea
#@onready var inventoryUI: Node = null

var safeSpot: Vector2

@export var WALK_SPEED = 200.0
@export var RUN_SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var CLIMB_VELOCITY = -150.0
@export var STANDING_JUMP_X = 100.0
@export var TELEPORT_BUFFER = 50

var playerMovement: PlayerMovementComponent
var playerTimetravel: PlayerTimetravelComponent
var playerInteraction: PlayerInteractionComponent

func _ready() -> void:
	playerMovement = PlayerMovementComponent.new(self)
	playerTimetravel = PlayerTimetravelComponent.new(self)
	playerInteraction = PlayerInteractionComponent.new(self)
	
	safeSpot = GlobalVars.spawnpointPresent
	playerMovement.changeState("IdleMotionState")

func _physics_process(delta: float) -> void:
	playerInteraction.processInput(delta)
	playerTimetravel.processInput(delta)
	velocity = playerMovement.processInput(delta)
	move_and_slide()

func _on_sprite_2d_frame_changed() -> void:
	if is_on_floor():
		if sprite_2d.frame == 2:
			left_foot.play()
		elif sprite_2d.frame == 5:
			right_foot.play()

func OnDeadlyAreaEntered() -> void:
	## block movement
	playerMovement.changeState("Unresponsive")
	## play dialog
	Dialogic.start("DieInWater")
