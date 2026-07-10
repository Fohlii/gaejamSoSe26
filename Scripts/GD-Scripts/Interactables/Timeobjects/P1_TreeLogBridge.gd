extends Timeobject

func _init() -> void:
	id = "PresentTreeLogOverRiver"
	_layer = InteractableLayer.ACTIVE
	_timeline = Timeline.PRESENT

func _ready() -> void:
	super()
	
	var treeLogNotInPlace: TimeobjectState = TimeobjectState.new("treeLogNotInPlace"
	).setPosition(Vector2(6012.0, -520.0)
	).setRotation(0
	).setTexture(""
	).setColliderPolygon([])
	
	var treeLogInPlace: TimeobjectState = TimeobjectState.new("treeLogInPlace"
	).setPosition(Vector2(6012.0, -520.0)
	).setRotation(0 #using rotation on collision polygon is not good.
	).setTexture("tree_log_bridge.png"
	).setColliderPolygon(
		[Vector2(-231.0, 7.0),
		Vector2(288.0, 70.0),
		Vector2(286.0, 86.0),
		Vector2(-231.0, 29.0)])
	
	treeLogNotInPlace.addCascadeTransition("treeFelled", treeLogInPlace.id)
	# TO-DO: add cascade transitions for if present tree leaves felled state
	
	_observedTimeobjects.push_back("PresentTreeNearRiver")
	
	_statesById.set(treeLogNotInPlace.id, treeLogNotInPlace)
	_statesById.set(treeLogInPlace.id, treeLogInPlace)
	
	_currentState = _statesById[treeLogNotInPlace.id]
	
