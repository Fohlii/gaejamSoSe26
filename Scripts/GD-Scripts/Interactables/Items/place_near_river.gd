extends Interactable
var id: String
var placeWithoutSaplingTexture = load("")
var placeWithSaplingTexture = load("res://icon.svg")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D
var future_tree: Callable

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

func interactWith(itemId: String) -> String:
	var returnValue = ""
	if canInteract && itemId == "sapling":
		returnValue = givesItem()
		canInteract = false
		sprite_2d.texture = placeWithSaplingTexture
		print("sapling planted")
		if future_tree:
			future_tree.call()
	return returnValue
