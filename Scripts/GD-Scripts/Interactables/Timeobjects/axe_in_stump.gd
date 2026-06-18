extends Timeobject

func _init() -> void:
	id = "PresentAxeStump"
	layer = InteractableLayer.BACKGROUND
	timeline = Timeline.PRESENT
	dependsOnOther = false

func _ready() -> void:
	var withAxe: TimeobjectState = TimeobjectState.new("stumpWithAxe", Vector2(2773.0,-342.0), 0, true, "res://Assets/Timeobjects/Textures/stump_with_axe.png", CircleShape2D.new(), "")
	var withoutAxe: TimeobjectState = TimeobjectState.new("stumpWithoutAxe", Vector2(2773.0,-342.0), 0, true, "res://Assets/Timeobjects/Textures/stump.png", CircleShape2D.new(), "res://Resources/Items/axe.tres")
	withAxe.addInteractionTransition("NONE", withoutAxe.id)
	withoutAxe.addInteractionTransition("axe", withAxe.id)
	
	statesById.set(withAxe.id, withAxe)
	statesById.set(withoutAxe.id, withoutAxe)
	
	currentState = withAxe
	
	super()
