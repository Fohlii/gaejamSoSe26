extends Timeobject

func _init() -> void:
	id = "PresentTreeNearRiver"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	var treeNotGrown: TimeobjectState = TimeobjectState.new("treeNotGrown", Vector2(3235.0,-357.0))
	var treeGrown: TimeobjectState = TimeobjectState.new("treeGrown", Vector2(3235.0,-357.0), 0, true, "tree.png")
	var treeFelled: TimeobjectState = TimeobjectState.new("treeFelled", Vector2(3235.0,-357.0), 0, true, "tree_felled.png")
	
	treeGrown.addInteractionTransition("axe", treeFelled.id)
	treeNotGrown.addCascadeTransition("saplingPlantedInSpot", treeGrown.id)
	
	_observedTimeobjects.push_back("PastSaplingPlantationSpot")
	
	_statesById.set(treeNotGrown.id, treeNotGrown)
	_statesById.set(treeGrown.id, treeGrown)
	_statesById.set(treeFelled.id, treeFelled)
	
	_currentState = _statesById[treeNotGrown.id]
	
	super()
