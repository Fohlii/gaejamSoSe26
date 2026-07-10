extends Timeobject

func _init() -> void:
	id = "PastCaveEntranceScaffolding"
	_layer = InteractableLayer.BACKGROUND
	_timeline = Timeline.PAST

func _ready() -> void:
	super()
	
	var scaffoldingNotBuilt: TimeobjectState = TimeobjectState.new("scaffoldingNotBuilt"
	).setPosition(Vector2(6482.0, -526.0)
	).setTexture("scaffolding_construction.png")
	
	var scaffoldingBuilt: TimeobjectState = TimeobjectState.new("scaffoldingBuilt"
	).setPosition(Vector2(6482.0, -526.0)
	).setTexture("scaffoldingFinished.png"
	).setScale(0.75)
	
	scaffoldingNotBuilt.addInteractionTransition("woodPlanks", scaffoldingBuilt.id)
	#scaffoldingBuilt.addInteractionTransition("axe", scaffoldingNotBuilt.id)
	
	_statesById.set(scaffoldingNotBuilt.id, scaffoldingNotBuilt)
	_statesById.set(scaffoldingBuilt.id, scaffoldingBuilt)
	
	_currentState = _statesById[scaffoldingNotBuilt.id]
	
