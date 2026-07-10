extends Timeobject

func _init() -> void:
	id = "PresentTreeForScaffoldingWood"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	super()
	
	var treeNotChopped: TimeobjectState = TimeobjectState.new("treeNotChopped"
	).setPosition(Vector2(4935.0, -617.0)
	).setTexture("tree.png")
	
	var treeFelled: TimeobjectState = TimeobjectState.new("treeFelled"
	).setPosition(Vector2(4935.0, -617.0)
	).setTexture("tree_logs.png"
	).setItem("P1_P2_axe.tres")
	
	var treeChoppedNoPlanks: TimeobjectState = TimeobjectState.new("treeChoppedNoPlanks"
	).setPosition(Vector2(4935.0, -617.0)
	).setTexture("tree_felled.png"
	).setItem("P2_woodPlanks.tres")
	
	var treePlanksDeposited: TimeobjectState = TimeobjectState.new("treePlanksDeposited"
	).setPosition(Vector2(4935.0, -617.0)
	).setTexture("tree_logs.png")
	
	treeNotChopped.addInteractionTransition("axe", treeFelled.id)
	treeFelled.addInteractionTransition("EMPTY_HAND", treeChoppedNoPlanks.id)
	
	treeChoppedNoPlanks.addInteractionTransition("woodPlanks", treePlanksDeposited.id)
	treePlanksDeposited.addInteractionTransition("EMPTY_HAND", treeChoppedNoPlanks.id)
	
	_statesById.set(treeNotChopped.id, treeNotChopped)
	_statesById.set(treeFelled.id, treeFelled)
	_statesById.set(treeChoppedNoPlanks.id, treeChoppedNoPlanks)
	_statesById.set(treePlanksDeposited.id, treePlanksDeposited)
	
	_currentState = _statesById[treeNotChopped.id]
	
