extends Interactable
var id: String
var stumpWithAxeTexture = load("")
var stumpWithoutAxeTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:	
	canInteract = true
	sprite_2d.texture = stumpWithAxeTexture

func needsItem() -> String:
	if canInteract:
		return ""
	else:
		return ""

func givesItem() -> String:
	if canInteract:
		return "axe"
	else:
		return ""

func interactWith(itemId: String) -> String:
	var returnValue = ""
	if canInteract:
		returnValue = givesItem()
		canInteract = false
		sprite_2d.texture = stumpWithoutAxeTexture
	return returnValue
