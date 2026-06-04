extends Interactable
var id: String
var noTreeTexture = load("")
var treeTexture = load("")
var felledTreeTexture = load("")
var canInteract: bool

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var treeBridge: Node2D

func _ready() -> void:	
	canInteract = true
	sprite_2d.texture = noTreeTexture

func needsItem() -> String:
	if canInteract:
		return "axe"
	else:
		return ""

func givesItem() -> String:
	if canInteract:
		return ""
	else:
		return ""

func interactWith(itemId: String) -> void:
	if canInteract && itemId == "axe":
		canInteract = false
		sprite_2d.texture = felledTreeTexture
		if treeBridge:
			treeBridge.set_process(PROCESS_MODE_INHERIT)
			treeBridge.visible = true
		else:
			print("treebridge reference not set in tree")
