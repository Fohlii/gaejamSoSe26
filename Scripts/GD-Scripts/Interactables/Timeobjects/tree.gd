extends Timeobject

func _init() -> void:
	id = "PresentTreeNearRiver"
	layer = InteractableLayer.BACKGROUND
	timeline = Timeline.PRESENT
	dependsOnOther = true

func _ready() -> void:
	var treeNotGrown: TimeobjectState = TimeobjectState.new("treeNotGrown", Vector2(3235.0,-357.0), 0, true, "", CircleShape2D.new(), "")
	var treeGrown: TimeobjectState = TimeobjectState.new("treeGrown", Vector2(3235.0,-357.0), 0, true, "res://icon.svg", CircleShape2D.new(), "")
	var treeFelled: TimeobjectState = TimeobjectState.new("treeFelled", Vector2(3235.0,-357.0), 0, true, "", CircleShape2D.new(), "")
	
	treeGrown.addInteractionTransition("axe", treeFelled.id)
	treeNotGrown.addCascadeTransition("PastSaplingPlantationSpot", "saplingPlantedInSpot", treeGrown.id)
	
	statesById.set(treeNotGrown.id, treeNotGrown)
	statesById.set(treeGrown.id, treeGrown)
	statesById.set(treeFelled.id, treeFelled)
	
	currentState = treeNotGrown
	
	super()
