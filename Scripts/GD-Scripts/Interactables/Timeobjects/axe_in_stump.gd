extends Timeobject

func _init() -> void:
	id = "PresentObjectStump"

func _ready() -> void:
	var withAxe: TimeobjectState = TimeobjectState.new("withAxe", Vector2.ZERO, "", "", true, "")
	var withoutAxe: TimeobjectState = TimeobjectState.new("withoutAxe", Vector2.ZERO, "", "", true, "axe")
	withAxe.addInteractionTransition("", "withoutAxe")
	withoutAxe.addInteractionTransition("axe", "withAxe")
	statesById.set("withAxe", withAxe)
	statesById.set("withoutAxe", withoutAxe)
	currentState = withAxe
	super()
