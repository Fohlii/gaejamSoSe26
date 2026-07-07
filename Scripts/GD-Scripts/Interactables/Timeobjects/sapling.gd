extends Timeobject

func _init() -> void:
	id = "PresentSaplingSource"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	super()
	
	var saplingNotTaken: TimeobjectState = TimeobjectState.new("saplingNotTaken"
	).setPosition(Vector2(3531.0, -485.0)
	).setTexture("sapling.png"
	).setSpriteOffset(Vector2(15,-35))
	
	var saplingTaken: TimeobjectState = TimeobjectState.new("saplingTaken"
	).setPosition(Vector2(3531.0, -485.0)
	).setTexture(
	).setItem("P1_sapling.tres")
	
	saplingNotTaken.addInteractionTransition("EMPTY_HAND", saplingTaken.id)
	#saplingTaken.addInteractionTransition("sapling", saplingNotTaken.id)
	
	_statesById.set(saplingNotTaken.id, saplingNotTaken)
	_statesById.set(saplingTaken.id, saplingTaken)
	
	_currentState = _statesById[saplingNotTaken.id]
	
