extends Timeobject

func _init() -> void:
	id = "PresentTreeForScaffoldingWood"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	super()
	
	var treeNotChopped: TimeobjectState = TimeobjectState.new("treeNotChopped"
	).setPosition(Vector2(4935.0, -767.0)
	).setTexture("tree.png")
	
	var treeFelled: TimeobjectState = TimeobjectState.new("treeFelled"
	).setPosition(Vector2(4935.0, -767.0)
	).setTexture("icon.svg"
	).setItem("P2_woodPlanks.tres")
	
	var treeChopped: TimeobjectState = TimeobjectState.new("treeChopped"
	).setPosition(Vector2(4935.0, -767.0)
	).setTexture("icon.svg"
	).setItem("P2_woodPlanks.tres")
	
	treeNotChopped.addInteractionTransition("axe", treeFelled.id)
	treeFelled.addInteractionTransition("EMPTY_HAND", treeChopped.id)
	#treeChopped.addInteractionTransition("woodPlanks", treeFelled.id)
	
	_statesById.set(treeNotChopped.id, treeNotChopped)
	_statesById.set(treeFelled.id, treeFelled)
	
	_currentState = _statesById[treeNotChopped.id]
	
