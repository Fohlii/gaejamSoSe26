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
	).setRotation(PI
	).setTexture("tree_log_bridge.png"
	).setColliderPolygon([Vector2(-201,21),Vector2(198,27),Vector2(198,-8),Vector2(-200,-18)])
	
	treeLogNotInPlace.addCascadeTransition("treeFelled", treeLogInPlace.id)
	# TO-DO: add cascade transitions for if present tree leaves felled state
	
	_observedTimeobjects.push_back("PresentTreeNearRiver")
	
	_statesById.set(treeLogNotInPlace.id, treeLogNotInPlace)
	_statesById.set(treeLogInPlace.id, treeLogInPlace)
	
	_currentState = _statesById[treeLogInPlace.id]
	
