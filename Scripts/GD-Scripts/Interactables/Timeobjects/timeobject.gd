class_name Timeobject extends Interactable
## A Timeobject is any instantiable in past or present that changes due to player action
## directly or indirectly through other Timeobjects

## All possible states for this Timeobject
var statesById: Dictionary[String, TimeobjectState]

## The current state of this Timeobject
var currentState: TimeobjectState

signal timeobject_state_changed(newStateId: String)

func _ready() -> void:
	if currentState.visibleAndColliding:
		sprite.texture = currentState.texture
		collider.shape = currentState.colliderShape
	for state in currentState.cascadeTransitions.keys():
		# TODO: test
		get_tree().root.get_script().timeobjectManager.timeobjectsById(state).timeobject_state_changed.connect(self.on_other_timeobject_state_changed)

## What happens when the player tries to interact with this Node. Note: return can be null if the item is consumed.
func interact(withItemId: String = "") -> Item:
	# TODO: test
	if currentState.interactionTransitions.keys().has(withItemId):
		_interactionTransition(withItemId)
		return currentState.itemToReturnOnTransition
	else:
		return null

func on_other_timeobject_state_changed(notifierStateId: String) -> void:
	# TODO: test
	_cascadeTransition(currentState.cascadeTransitions[notifierStateId])

func _interactionTransition(itemId: String) -> void:
	# TODO: test
	for state in currentState.cascadeTransitions.keys():
		get_tree().root.get_script().timeobjectManager.timeobjectsById(state).timeobject_state_changed.disconnect(self.on_timeobject_state_changed)
	currentState = statesById[currentState.interactionTransitions[itemId]]
	for state in currentState.cascadeTransitions.keys():
		get_tree().root.get_script().timeobjectManager.timeobjectsById(state).timeobject_state_changed.connect(self.on_timeobject_state_changed)
	timeobject_state_changed.emit(currentState.id)

func _cascadeTransition(newStateId: String) -> void:
	# TODO: test
	for state in currentState.cascadeTransitions.keys():
		get_tree().root.get_script().timeobjectManager.timeobjectsById(state).timeobject_state_changed.disconnect(self.on_timeobject_state_changed)
	currentState = statesById[currentState.cascadeTransitions[newStateId]]
	for state in currentState.cascadeTransitions.keys():
		get_tree().root.get_script().timeobjectManager.timeobjectsById(state).timeobject_state_changed.connect(self.on_timeobject_state_changed)
	timeobject_state_changed.emit(currentState.id)

class TimeobjectState extends Resource:
	var id: String
	var pos: Vector2
	var texture: Texture2D
	var colliderShape: Shape2D
	var visibleAndColliding: bool
	var itemToReturnOnTransition: Item
	var interactionTransitions: Dictionary[String, String] ## ItemIds map to TimeobjectStateIds
	var cascadeTransitions: Dictionary[String, String] ## notifier-TimeobjectStateIds map to own TimeobjectStateIds
	
	func _init(id: String, pos: Vector2, tex: String, col: String, vis: bool, item: String) -> void:
		self.id = id
		self.pos = pos
		self.texture = load(tex)
		self.colliderShape = load(col)
		self.visibleAndColliding = vis
		self.itemToReturnOnTransition = load(item)
		self.interactions = {}
		self.cascadeTransitions = {}
	
	func addInteractionTransition(itemId: String, stateId: String):
		self.interactions.set(itemId, stateId)
	
	func addCascadeTransition(notifierStateId: String, ownStateId: String):
		self.cascadeTransitions.set(notifierStateId, ownStateId)
