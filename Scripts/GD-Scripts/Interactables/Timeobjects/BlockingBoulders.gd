extends Timeobject

func _init() -> void:
	id = "PresentBlockingBoulders"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var blockingEntrance: TimeobjectState = TimeobjectState.new("blockingEntrance", Vector2.ZERO)
	var caughtByScaffolding: TimeobjectState = TimeobjectState.new("stackedOnScaffolding", Vector2.ZERO)
	
	blockingEntrance.addCascadeTransition("scaffoldingBuilt", caughtByScaffolding.id)
	
	_observedTimeobjects.push_back("PastCaveEntranceScaffolding")
	
	_statesById.set(blockingEntrance.id, blockingEntrance)
	_statesById.set(caughtByScaffolding.id, caughtByScaffolding)
	
	_currentState = _statesById[blockingEntrance.id]
	
	super()
