@abstract class_name Interactable extends StaticBody2D
## A custom project-unique, interactable-unique identifier
var id: String

## Which layer (same as player or behind) this Node is encountered in
var _layer: InteractableLayer

## Which Scene (PastRoot or PresentRoot) this Node is encountered in
var _timeline: Timeline

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _collider: CollisionPolygon2D = $CollisionPolygon2D
@onready var _interactionArea: Area2D = $InteractionArea2D

enum InteractableLayer {ACTIVE, BACKGROUND, FOREGROUND}
enum Timeline {PAST, PRESENT}

func _ready() -> void:
	## enable player collision for objects in active layer
	if _layer == InteractableLayer.ACTIVE:
		set_collision_layer_value(2, true)

@abstract func interact(item: Item) -> Item
