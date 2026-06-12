extends Timeobject

func _init() -> void:
	id = "PresentTreeLogOverRiver"
	layer = InteractableLayer.ACTIVE
	timeline = Timeline.PRESENT
	dependsOnOther = true

func _ready() -> void:
	var treeLogNotInPlace: TimeobjectState = TimeobjectState.new("treeLogNotInPlace", Vector2(3519.0,-332.0), 0, false, "", CapsuleShape2D.new(), "")
	var treeLogInPlace: TimeobjectState = TimeobjectState.new("treeLogInPlace", Vector2(3519.0,-332.0), PI, true, "res://icon.svg", CapsuleShape2D.new(), "")
	
	treeLogNotInPlace.addCascadeTransition("PresentTreeNearRiver", "treeFelled", treeLogInPlace.id)
	
	statesById.set(treeLogNotInPlace.id, treeLogNotInPlace)
	statesById.set(treeLogInPlace.id, treeLogInPlace)
	
	currentState = treeLogNotInPlace
	
	super()
