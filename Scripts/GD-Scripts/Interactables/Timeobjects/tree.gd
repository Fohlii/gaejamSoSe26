extends Timeobject
var noTreeTexture = load("")
var treeTexture = load("res://icon.svg")
var felledTreeTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var treeBridge: StaticBody2D

func _ready() -> void:	
	canInteract = true
	sprite_2d.texture = noTreeTexture

func PlantTree() -> void:
	if sprite_2d.texture == noTreeTexture:
		sprite_2d.texture = treeTexture
		print("a tree has grown")

func needsItem() -> String:
	if canInteract && (sprite_2d.texture == treeTexture):
		return "axe"
	else:
		return ""

func givesItem() -> String:
	if canInteract:
		return ""
	else:
		return ""

func interactWith(itemId: String) -> String:
	var returnValue = ""
	if canInteract && itemId == "axe" && (sprite_2d.texture == treeTexture):
		returnValue = givesItem()
		canInteract = false
		sprite_2d.texture = felledTreeTexture
		if treeBridge:
			treeBridge.set_collision_layer_value(5,true)
			treeBridge.visible = true
		else:
			print("treebridge reference not set in tree")
	return returnValue
