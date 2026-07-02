extends Timeobject

func _init() -> void:
	id = "PresentAxeStump"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var withAxe: TimeobjectState = TimeobjectState.new("stumpWithAxe", Vector2(4698.0, -640.0), 0, 1.0, true, "stump_with_axe.png")
	var withoutAxe: TimeobjectState = TimeobjectState.new("stumpWithoutAxe", Vector2(4698.0, -640.0), 0, 1.0, true, "stump.png", Vector2.ZERO, [], "P1_P2_axe.tres")
	withAxe.addInteractionTransition("EMPTY_HAND", withoutAxe.id)
	withoutAxe.addInteractionTransition("axe", withAxe.id)
	
	_statesById.set(withAxe.id, withAxe)
	_statesById.set(withoutAxe.id, withoutAxe)
	
	_currentState = _statesById[withAxe.id]
	
	super()
