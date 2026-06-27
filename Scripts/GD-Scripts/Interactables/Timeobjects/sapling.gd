extends Timeobject

func _init() -> void:
	id = "PresentSaplingSource"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var saplingNotTaken: TimeobjectState = TimeobjectState.new("saplingNotTaken", Vector2(2111.0,-337.0), 0, true, "sapling.png", Vector2(15,-35))
	var saplingTaken: TimeobjectState = TimeobjectState.new("saplingTaken", Vector2(2111.0,-337.0), 0, true, "", Vector2.ZERO, [], "sapling.tres")
	saplingNotTaken.addInteractionTransition("EMPTY_HAND", saplingTaken.id)
	
	_statesById.set(saplingNotTaken.id, saplingNotTaken)
	_statesById.set(saplingTaken.id, saplingTaken)
	
	_currentState = _statesById[saplingNotTaken.id]
	
	super()
