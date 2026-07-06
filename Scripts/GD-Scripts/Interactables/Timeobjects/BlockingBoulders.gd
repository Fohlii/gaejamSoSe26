extends Timeobject

func _init() -> void:
	id = "PresentBlockingBoulders"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var blockingEntrance: TimeobjectState = TimeobjectState.new("blockingEntrance", Vector2.ZERO, 0, 1.0, true, "", Vector2.ZERO, PackedVector2Array([
	Vector2(-48.0, 55.0),
	Vector2(-61.0, 35.0),
	Vector2(-61.0, 12.0),
	Vector2(-48.0, -13.0),
	Vector2(-28.0, -26.0),
	Vector2(-19.0, -58.0),
	Vector2(-3.0, -86.0),
	Vector2(18.0, -116.0),
	Vector2(34.0, -119.0),
	Vector2(47.0, -86.0),
	Vector2(49.0, -58.0),
	Vector2(57.0, -27.0),
	Vector2(75.0, -16.0),
	Vector2(85.0, 10.0),
	Vector2(81.0, 34.0),
	Vector2(62.0, 55.0)]))
	var caughtByScaffolding: TimeobjectState = TimeobjectState.new("stackedOnScaffolding", Vector2.ZERO)
	
	blockingEntrance.addCascadeTransition("scaffoldingBuilt", caughtByScaffolding.id)
	
	_observedTimeobjects.push_back("PastCaveEntranceScaffolding")
	
	_statesById.set(blockingEntrance.id, blockingEntrance)
	_statesById.set(caughtByScaffolding.id, caughtByScaffolding)
	
	_currentState = _statesById[blockingEntrance.id]
	
	super()
