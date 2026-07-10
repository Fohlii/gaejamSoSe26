extends Timeobject

func _init() -> void:
	id = "PastSaplingPlantationSpot"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	super()
	
	var withoutSapling: TimeobjectState = TimeobjectState.new("emptyPlantationSpot"
	).setPosition(Vector2(5650.0,-550.0)
	).setTexture("icon.svg"
	)#.setItem("P1_sapling.tres")
	
	var withSapling: TimeobjectState = TimeobjectState.new("saplingPlantedInSpot"
	).setPosition(Vector2(5650.0,-550.0)
	).setTexture("sapling.png")
	
	withoutSapling.addInteractionTransition("sapling", withSapling.id)
	#withSapling.addInteractionTransition("EMPTY_HAND", withoutSapling.id)
	
	_statesById.set(withoutSapling.id, withoutSapling)
	_statesById.set(withSapling.id, withSapling)
	
	_currentState = _statesById[withoutSapling.id]
	
