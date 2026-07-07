extends Timeobject

func _init() -> void:
	id = "PresentTreeForScaffoldingWood"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	super()
	
	var treeNotChopped: TimeobjectState = TimeobjectState.new("treeNotChopped"
	).setPosition(Vector2(5138.0, -621.0)
	).setTexture("tree.png")
	
	var treeChopped: TimeobjectState = TimeobjectState.new("treeChopped"
	).setPosition(Vector2(5138.0, -621.0)
	).setTexture("icon.svg"
	).setItem("P2_woodPlanks.tres") # by doing this, the axe will be "consumed"
	
	treeNotChopped.addInteractionTransition("axe", treeChopped.id)
	#treeChopped.addInteractionTransition("axe", treeChopped.id)
	
	_statesById.set(treeNotChopped.id, treeNotChopped)
	_statesById.set(treeChopped.id, treeChopped)
	
	_currentState = _statesById[treeNotChopped.id]
	
