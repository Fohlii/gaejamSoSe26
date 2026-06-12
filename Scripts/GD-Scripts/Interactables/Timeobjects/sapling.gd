extends Timeobject

func _init() -> void:
	id = "PresentSaplingSource"
	layer = InteractableLayer.BACKGROUND
	timeline = Timeline.PRESENT
	dependsOnOther = false

func _ready() -> void:
	var saplingNotTaken: TimeobjectState = TimeobjectState.new("saplingNotTaken", Vector2(2111.0,-337.0), 0, true, "", CircleShape2D.new(), "")
	var saplingTaken: TimeobjectState = TimeobjectState.new("saplingTaken", Vector2(2111.0,-337.0), 0, true, "res://icon.svg", CircleShape2D.new(), "res://Resources/Items/sapling.tres")
	saplingNotTaken.addInteractionTransition("NONE", saplingTaken.id)
	
	statesById.set(saplingNotTaken.id, saplingNotTaken)
	statesById.set(saplingTaken.id, saplingTaken)
	
	currentState = saplingNotTaken
	
	super()
