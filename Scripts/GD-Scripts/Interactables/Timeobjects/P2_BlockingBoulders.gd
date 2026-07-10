extends Timeobject

func _init() -> void:
	id = "PresentBlockingBoulders"
	_layer = InteractableLayer.ACTIVE
	_timeline = Timeline.PRESENT

func _ready() -> void:
	super()
	
	var blockingEntrance: TimeobjectState = TimeobjectState.new("blockingEntrance"
	).setPosition(Vector2(6440.0, -549.0)
	).setColliderPolygon(
		[Vector2(-84.0, 96.0),
		Vector2(-106.0, 61.0),
		Vector2(-107.0, 21.0),
		Vector2(-84.0, -22.0),
		Vector2(-49.0, -45.0),
		Vector2(-33.0, -102.0),
		Vector2(-5.0, -149.0),
		Vector2(32.0, -203.0),
		Vector2(59.0, -208.0),
		Vector2(82.0, -150.0),
		Vector2(85.0, -101.0),
		Vector2(100.0, -47.0),
		Vector2(131.0, -28.0),
		Vector2(149.0, 18.0),
		Vector2(142.0, 59.0),
		Vector2(109.0, 96.0)]
	).setTexture("icon.svg")
	
	var caughtByScaffolding: TimeobjectState = TimeobjectState.new("caughtByScaffolding"
	).setPosition(Vector2(6116.0, -442.0) #untested location
	).setColliderPolygon([]
	).setTexture("icon.svg")
	
	blockingEntrance.addCascadeTransition("scaffoldingBuilt", caughtByScaffolding.id)
	#caughtByScaffolding.addCascadeTransition("scaffoldingNotBuilt", blockingEntrance.id)
	
	_observedTimeobjects.push_back("PastCaveEntranceScaffolding")
	
	_statesById.set(blockingEntrance.id, blockingEntrance)
	_statesById.set(caughtByScaffolding.id, caughtByScaffolding)
	
	_currentState = _statesById[caughtByScaffolding.id]
	
