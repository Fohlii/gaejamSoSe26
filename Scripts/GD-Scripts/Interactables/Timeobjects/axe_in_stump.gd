extends Timeobject

func _init() -> void:
	id = "PresentAxeStump"
	layer = InteractableLayer.BACKGROUND
	timeline = Timeline.PRESENT
	dependsOnPast = false

func _ready() -> void:
	var withAxe: TimeobjectState = TimeobjectState.new("stumpWithAxe", Vector2(2773.0,-342.0), true, "res://icon.svg", "", "NONE")
	var withoutAxe: TimeobjectState = TimeobjectState.new("stumpWithoutAxe", Vector2(2773.0,-342.0), true, "", "", "axe")
	withAxe.addInteractionTransition("NONE", withoutAxe.id)
	withoutAxe.addInteractionTransition("axe", withAxe.id)
	
	statesById.set(withAxe.id, withAxe)
	statesById.set(withoutAxe.id, withoutAxe)
	
	currentState = withAxe

	super()
