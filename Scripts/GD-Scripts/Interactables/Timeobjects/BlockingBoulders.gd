extends Timeobject

func _init() -> void:
	id = "PresentBlockingBoulders"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var blockingEntrance: TimeobjectState = TimeobjectState.new("blockingEntrance"
	).setPosition(Vector2(8916.0, -592.0)
	).setVisibility(true
	).setColliderPolygon([Vector2(-48.0, 55.0), Vector2(-61.0, 35.0), Vector2(-61.0, 12.0), Vector2(-48.0, -13.0), Vector2(-28.0, -26.0), Vector2(-19.0, -58.0), Vector2(-3.0, -86.0), Vector2(18.0, -116.0), Vector2(34.0, -119.0), Vector2(47.0, -86.0), Vector2(49.0, -58.0), Vector2(57.0, -27.0), Vector2(75.0, -16.0), Vector2(85.0, 10.0), Vector2(81.0, 34.0), Vector2(62.0, 55.0)]
	).setTexture("icon.svg")
	var caughtByScaffolding: TimeobjectState = TimeobjectState.new("stackedOnScaffolding"
	).setVisibility(false
	).setTexture("icon.svg")
	
	blockingEntrance.addCascadeTransition("scaffoldingBuilt", caughtByScaffolding.id)
	
	_observedTimeobjects.push_back("PastCaveEntranceScaffolding")
	
	_statesById.set(blockingEntrance.id, blockingEntrance)
	_statesById.set(caughtByScaffolding.id, caughtByScaffolding)
	
	_currentState = _statesById[blockingEntrance.id]
	
	super()
