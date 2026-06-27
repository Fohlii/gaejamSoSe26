extends Timeobject

func _init() -> void:
	id = "PastSaplingPlantationSpot"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	var withoutSapling: TimeobjectState = TimeobjectState.new("emptyPlantationSpot", Vector2(3235.0,-357.0))
	var withSapling: TimeobjectState = TimeobjectState.new("saplingPlantedInSpot", Vector2(3235.0,-357.0), 0, true, "sapling.png")
	
	withoutSapling.addInteractionTransition("sapling", withSapling.id)
	
	_statesById.set(withoutSapling.id, withoutSapling)
	_statesById.set(withSapling.id, withSapling)
	
	_currentState = _statesById[withoutSapling.id]
	
	super()
