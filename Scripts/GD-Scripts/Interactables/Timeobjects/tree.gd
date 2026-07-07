extends Timeobject

func _init() -> void:
	id = "PresentTreeNearRiver"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PRESENT

func _ready() -> void:
	super()
	
	var treeNotGrown: TimeobjectState = TimeobjectState.new("treeNotGrown"
	).setPosition(Vector2(5543.0,-584.0))
	
	var treeGrown: TimeobjectState = TimeobjectState.new("treeGrown"
	).setPosition(Vector2(5543.0,-584.0)
	).setTexture("tree.png")
	
	var treeFelled: TimeobjectState = TimeobjectState.new("treeFelled"
	).setPosition(Vector2(5543.0,-584.0)
	).setTexture("tree_felled.png")
	
	treeGrown.addInteractionTransition("axe", treeFelled.id)
	treeNotGrown.addCascadeTransition("saplingPlantedInSpot", treeGrown.id)
	# TO-DO: additional states to return from grown tree to ungrown tree if sapling in past changes.
	
	_observedTimeobjects.push_back("PastSaplingPlantationSpot")
	
	_statesById.set(treeNotGrown.id, treeNotGrown)
	_statesById.set(treeGrown.id, treeGrown)
	_statesById.set(treeFelled.id, treeFelled)
	
	_currentState = _statesById[treeNotGrown.id]
	
