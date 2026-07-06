extends Timeobject

func _init() -> void:
	id = "PresentTreeForScaffoldingWood"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var treeNotChopped: TimeobjectState = TimeobjectState.new("treeNotChopped", Vector2.ZERO, 0, 1.0, true, "tree.png")
	var treeChopped: TimeobjectState = TimeobjectState.new("treeChopped", Vector2.ZERO, 0, 1.0, true, "", Vector2.ZERO, [], "P2_woodPlanks.tres")
	
	treeNotChopped.addInteractionTransition("axe", treeChopped.id)
	
	_statesById.set(treeNotChopped.id, treeNotChopped)
	_statesById.set(treeChopped.id, treeChopped)
	
	_currentState = _statesById[treeNotChopped.id]
	
	super()
