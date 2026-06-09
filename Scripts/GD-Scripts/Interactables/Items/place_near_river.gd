extends Interactable
var id: String
var placeWithoutSaplingTexture = load("")
var placeWithSaplingTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var tree: Node2D

func _ready() -> void:	
	canInteract = true
	sprite_2d.texture = placeWithoutSaplingTexture
	if not tree:
		tree = $"../../../../PresentRoot"/Areas/Mountain/BackLayer/Objects/tree
	print(tree)

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
		if tree:
			tree.set_process(PROCESS_MODE_INHERIT)
			tree.get_script().sprite_2d.texture = tree.get_script().treeTexture
		else:
			print("tree reference not set in tree placement location in past")
	return returnValue
