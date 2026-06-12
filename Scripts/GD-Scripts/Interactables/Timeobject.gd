@abstract class_name Timeobject extends Interactable
## A Timeobject is any instantiable in past or present that changes due to player action
## directly or indirectly through other Timeobjects

## All possible states for this Timeobject
var statesById: Dictionary[String, TimeobjectState]

## The current state of this Timeobject
var currentState: TimeobjectState

## Whether this Present-Timeobject depends on player action in the past
var dependsOnPast: bool = false

signal timeobject_state_changed(notifierId: String, notifierStateId: String)

func _ready() -> void:
	if currentState && currentState.visibleAndColliding:
		if sprite && currentState.texture:
			sprite.texture = currentState.texture
		if collider && currentState.colliderShape:
			collider.shape = currentState.colliderShape

func initializeAfterReadyStepOne() -> void:
	get_tree().current_scene.timeobjectManager.timeobjectsById.set(id, self)

func initializeAfterReadyStepTwo() -> void:
	if dependsOnPast:
		_registerListeners()

func _registerListeners() -> void:
	for notifierId in currentState.pastTimeobjects:
		get_tree().current_scene.timeobjectManager.timeobjectsById(notifierId).timeobject_state_changed.connect(self.on_other_timeobject_state_changed)

func _deregisterListeners() -> void:
	for notifierId in currentState.pastTimeobjects:
		get_tree().current_scene.timeobjectManager.timeobjectsById(notifierId).timeobject_state_changed.connect(self.on_other_timeobject_state_changed)

## What happens when the player tries to interact with this Node. Note: return can be null if the item is consumed.
func interact(itemId: String = "") -> Item:
	if currentState.interactionTransitions.keys().has(itemId):
		_interactionTransition(itemId)
		return currentState.itemToReturnOnTransition
	else:
		return null

func on_other_timeobject_state_changed(notifierStateId: String) -> void:
	if currentState.cascadeTransitions.keys().has(notifierStateId):
		_cascadeTransition(currentState.cascadeTransitions[notifierStateId])

func _interactionTransition(itemId: String) -> void:
	if dependsOnPast:
		_deregisterListeners()
	currentState = statesById[currentState.interactionTransitions[itemId]]
	if dependsOnPast:
		_registerListeners()
	timeobject_state_changed.emit(currentState.id)

func _cascadeTransition(newStateId: String) -> void:
	_deregisterListeners()
	currentState = statesById[newStateId]
	_registerListeners()
	timeobject_state_changed.emit(currentState.id)

class TimeobjectState extends Resource:
	var id: String
	var pos: Vector2
	var visibleAndColliding: bool
	var texture: Texture2D
	var colliderShape: Shape2D
	var itemToReturnOnTransition: Item
	var interactionTransitions: Dictionary[String, String] ## ItemId mapped to own TimeobjectStateId
	var pastTimeobjects: Array[String] ## TimeobjectIDs that this Timeobject's state depends on
	var cascadeTransitions: Dictionary[String, String] ## notifierStateId mapped to own TimeobjectStateId
	
	func _init(id: String, pos: Vector2, vis: bool, tex: String, col: String, item: String) -> void:
		self.id = id
		self.pos = pos
		self.visibleAndColliding = vis
		self.texture = load(tex)
		self.colliderShape = load(col)
		self.itemToReturnOnTransition = load(item)
		self.interactionTransitions = {}
		self.pastTimeobjects = []
		self.cascadeTransitions = {}
	
	func addInteractionTransition(itemId: String, stateId: String):
		self.interactionTransitions.set(itemId, stateId)
	
	func addCascadeTransition(notifierId: String, notifierStateId: String, ownStateId: String):
		self.pastTimeobjects.push_back(notifierId)
		self.cascadeTransitions.set(notifierStateId, ownStateId)
