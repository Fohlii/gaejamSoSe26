extends Timeobject

func _init() -> void:
	id = "PastCaveEntranceScaffolding"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	var scaffoldingNotBuilt: TimeobjectState = TimeobjectState.new("scaffoldingNotBuilt", Vector2.ZERO)
	var scaffoldingBuilt: TimeobjectState = TimeobjectState.new("scaffoldingBuilt", Vector2.ZERO)
	
	scaffoldingNotBuilt.addInteractionTransition("woodPlanks", scaffoldingBuilt.id)
	
	_statesById.set(scaffoldingNotBuilt.id, scaffoldingNotBuilt)
	_statesById.set(scaffoldingBuilt.id, scaffoldingBuilt)
	
	_currentState = _statesById[scaffoldingNotBuilt.id]
	
	super()
