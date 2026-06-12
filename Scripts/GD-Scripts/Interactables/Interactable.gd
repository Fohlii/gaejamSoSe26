@abstract class_name Interactable extends Node2D
var id: String

## Which layer (same as player or behind) this Node is encountered in
var layer: InteractableLayer

## Which Scene (PastRoot or PresentRoot) this Node is encountered in
var timeline: Timeline

@onready var sprite: Sprite2D
@onready var collider: Variant ## Either collisionshape or collisionpolygon

enum InteractableLayer {ACTIVE, BACKGROUND}
enum Timeline {PAST, PRESENT}

func interact(item: Item) -> Item:
	return null
