@abstract class_name Timeobject extends Interactable
## A Timeobject is any instantiable in past or present that changes due to player action
## directly or indirectly through other Timeobjects

## All possible states for this Timeobject
var statesById: Dictionary[String, TimeobjectState]

## The current state of this Timeobject
var currentState: TimeobjectState

signal timeobject_state_changed(notifierId: String, notifierStateId: String)

func _ready() -> void:
	if currentState.visibleAndColliding:
		sprite.texture = currentState.texture
		collider.shape = currentState.colliderShape

func initializeAfterReadyStepOne() -> void:
	get_tree().current_scene.timeobjectManager.timeobjectsById.set(id, self)

func initializeAfterReadyStepTwo() -> void:
	for tuple in currentState.cascadeTransitions.keys():
		get_tree().current_scene.timeobjectManager.timeobjectsById(tuple.first).timeobject_state_changed.connect(self.on_other_timeobject_state_changed)

## What happens when the player tries to interact with this Node. Note: return can be null if the item is consumed.
func interact(withItemId: String = "") -> Item:
	if currentState.interactionTransitions.keys().has(withItemId):
		_interactionTransition(withItemId)
		return currentState.itemToReturnOnTransition
	else:
		return null

func on_other_timeobject_state_changed(notifierId: String, notifierStateId: String) -> void:
	_cascadeTransition(currentState.cascadeTransitions[StringTuple.new(notifierId, notifierStateId)]) #TODO test if this works as key

func _interactionTransition(itemId: String) -> void:
	for tuple in currentState.cascadeTransitions.keys():
		get_tree().current_scene.timeobjectManager.timeobjectsById(tuple.first).timeobject_state_changed.disconnect(self.on_timeobject_state_changed)
	currentState = statesById[currentState.interactionTransitions[itemId]]
	for tuple in currentState.cascadeTransitions.keys():
		get_tree().current_scene.timeobjectManager.timeobjectsById(tuple.first).timeobject_state_changed.connect(self.on_timeobject_state_changed)
	timeobject_state_changed.emit(currentState.id)

func _cascadeTransition(newStateId: String) -> void:
	for tuple in currentState.cascadeTransitions.keys():
		get_tree().current_scene.timeobjectManager.timeobjectsById(tuple.first).timeobject_state_changed.disconnect(self.on_timeobject_state_changed)
	currentState = statesById[newStateId]
	for tuple in currentState.cascadeTransitions.keys():
		get_tree().current_scene.timeobjectManager.timeobjectsById(tuple.first).timeobject_state_changed.connect(self.on_timeobject_state_changed)
	timeobject_state_changed.emit(currentState.id)


class StringTuple extends RefCounted:
	var first: String
	var second: String
	
	func _init(first: String, second: String):
		self.first = first
		self.second = second


class TimeobjectState extends Resource:
	var id: String
	var pos: Vector2
	var texture: Texture2D
	var colliderShape: Shape2D
	var visibleAndColliding: bool
	var itemToReturnOnTransition: Item
	var interactionTransitions: Dictionary[String, String] ## ItemIds map to TimeobjectStateIds
	var cascadeTransitions: Dictionary[StringTuple, String] ## notifierId and notifierStateIds map to own TimeobjectStateIds
	
	func _init(id: String, pos: Vector2, tex: String, col: String, vis: bool, item: String):
		self.id = id
		self.pos = pos
		self.texture = load(tex)
		self.colliderShape = load(col)
		self.visibleAndColliding = vis
		self.itemToReturnOnTransition = load(item)
		self.interactions = {}
		self.cascadeTransitions = {}
	
	func addInteractionTransition(itemId: String, stateId: String):
		self.interactionTransitions.set(itemId, stateId)
	
	func addCascadeTransition(notifierStateId: String, ownStateId: String):
		self.cascadeTransitions.set(notifierStateId, ownStateId)
