extends Timeobject
var saplingTexture = load("res://icon.svg")
var noSaplingTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:	
	canInteract = true
	sprite_2d.texture = saplingTexture

func needsItem() -> String:
	if canInteract:
		return ""
	else:
		return ""

func givesItem() -> String:
	if canInteract:
		return "sapling"
	else:
		return ""

func interactWith(itemId: String) -> String:
	var returnValue = ""
	if canInteract:
		returnValue = givesItem()
		canInteract = false
		sprite_2d.texture = noSaplingTexture
	return returnValue
