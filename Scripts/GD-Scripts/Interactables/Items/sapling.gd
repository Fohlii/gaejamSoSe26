extends Interactable
var id: String
var saplingTexture = load("")
var noSaplingTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var tree: Node2D

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

func interactWith(itemId: String) -> void:
	if canInteract:
		canInteract = false
		sprite_2d.texture = noSaplingTexture
		if tree:
			tree.set_process(PROCESS_MODE_INHERIT)
			tree.get_script().sprite_2d.texture = tree.get_script().treeTexture
		else:
			print("tree reference not set in sapling")
