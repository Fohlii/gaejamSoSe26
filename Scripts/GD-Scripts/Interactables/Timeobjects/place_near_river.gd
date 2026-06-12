extends Timeobject

func _init() -> void:
	id = "PastSaplingPlantationSpot"
	layer = InteractableLayer.BACKGROUND
	timeline = Timeline.PAST
	dependsOnPast = false

func _ready() -> void:
	var withoutSapling: TimeobjectState = TimeobjectState.new("emptyPlantationSpot", Vector2(0,0), true, "", "", "NONE")
	var withSapling: TimeobjectState = TimeobjectState.new("saplingPlantedInSpot", Vector2(0,0), true, "res://icon.svg", "", "NONE")
	withoutSapling.addInteractionTransition("sapling", withSapling.id)
	
	statesById.set(withoutSapling.id, withoutSapling)
	statesById.set(withSapling.id, withSapling)
	
	currentState = withoutSapling

	super()
