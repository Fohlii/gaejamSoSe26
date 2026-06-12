extends Timeobject

func _init() -> void:
	id = "PastSaplingPlantationSpot"
	layer = InteractableLayer.BACKGROUND
	timeline = Timeline.PAST
	dependsOnOther = false

func _ready() -> void:
	var withoutSapling: TimeobjectState = TimeobjectState.new("emptyPlantationSpot", Vector2(3235.0,-357.0), 0, true, "", CircleShape2D.new(), "NONE")
	var withSapling: TimeobjectState = TimeobjectState.new("saplingPlantedInSpot", Vector2(3235.0,-357.0), 0, true, "res://icon.svg", CircleShape2D.new(), "NONE")
	withoutSapling.addInteractionTransition("sapling", withSapling.id)
	
	statesById.set(withoutSapling.id, withoutSapling)
	statesById.set(withSapling.id, withSapling)
	
	currentState = withoutSapling
	
	super()
