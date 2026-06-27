extends Timeobject

func _init() -> void:
	id = "PresentTreeLogOverRiver"
	_layer = InteractableLayer.ACTIVE
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var treeLogNotInPlace: TimeobjectState = TimeobjectState.new("treeLogNotInPlace", Vector2(3519.0,-332.0))
	var treeLogInPlace: TimeobjectState = TimeobjectState.new("treeLogInPlace", Vector2(3519.0,-332.0), PI, 1.0, true, "tree_log_bridge.png", Vector2.ZERO, [Vector2(-201,21),Vector2(198,27),Vector2(198,-8),Vector2(-200,-18)])
	
	treeLogNotInPlace.addCascadeTransition("treeFelled", treeLogInPlace.id)
	
	_observedTimeobjects.push_back("PresentTreeNearRiver")
	
	_statesById.set(treeLogNotInPlace.id, treeLogNotInPlace)
	_statesById.set(treeLogInPlace.id, treeLogInPlace)
	
	_currentState = _statesById[treeLogNotInPlace.id]
	
	super()
