extends Interactable
var id: String
var placeWithoutSaplingTexture = load("")
var placeWithSaplingTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:	
	canInteract = true
	sprite_2d.texture = placeWithoutSaplingTexture

func needsItem() -> String:
	if canInteract:
		return "sapling"
	else:
		return ""

func givesItem() -> String:
	if canInteract:
		return ""
	else:
		return ""

func interactWith(itemId: String) -> void:
	if canInteract && itemId == "sapling":
		canInteract = false
		sprite_2d.texture = placeWithSaplingTexture
