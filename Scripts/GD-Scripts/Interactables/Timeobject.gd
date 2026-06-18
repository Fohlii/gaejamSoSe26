@abstract class_name Timeobject extends Interactable
## A Timeobject is any instantiable in past or present that changes due to player action
## directly or indirectly through other Timeobjects

## All possible states for this Timeobject
var statesById: Dictionary[String, TimeobjectState]

## The current state of this Timeobject
var currentState: TimeobjectState

## Whether this Present-Timeobject depends on player interaction with another Timeobject
var dependsOnOther: bool = false

signal timeobject_state_changed(notifierStateId: String)

func _ready() -> void:
	if currentState && currentState.visibleAndColliding:
		if sprite && currentState.texture:
			sprite.texture = currentState.texture
			print("set texture for " + id)
		if collider && currentState.colliderShape:
			collider.shape = currentState.colliderShape
			print("set collider for " + id)
	get_tree().current_scene.ready.connect(initializeAfterReadyStepOne)

func initializeAfterReadyStepOne() -> void:
	get_tree().current_scene.timeobjectManager.timeobjectsById.set(id, self)
	
func initializeAfterReadyStepTwo() -> void:
	if dependsOnOther:
		_registerListeners()

func _registerListeners() -> void:
	for notifierId in currentState.otherTimeobjects:
		get_tree().current_scene.timeobjectManager.timeobjectsById[notifierId].timeobject_state_changed.connect(self.on_other_timeobject_state_changed)
		print(id, " registered listener in ", currentState.id, " for ", notifierId)

func _deregisterListeners() -> void:
	for notifierId in currentState.otherTimeobjects:
		get_tree().current_scene.timeobjectManager.timeobjectsById[notifierId].timeobject_state_changed.disconnect(self.on_other_timeobject_state_changed)

## What happens when the player tries to interact with this Node. Note: return can be null if the item is consumed.
func interact(item: Item) -> Item:
	if !item && currentState.interactionTransitions.keys().has("NONE"):
		_interactionTransition("NONE")
		return currentState.itemToReturnOnTransition
	elif item && currentState.interactionTransitions.keys().has(item.id):
		_interactionTransition(item.id)
		return currentState.itemToReturnOnTransition
	else:
		return item # return item if not used

func on_other_timeobject_state_changed(notifierStateId: String) -> void:
	if currentState.cascadeTransitions.keys().has(notifierStateId):
		_cascadeTransition(currentState.cascadeTransitions[notifierStateId])

func _interactionTransition(itemId: String) -> void:
	if dependsOnOther:
		_deregisterListeners()
	currentState = statesById[currentState.interactionTransitions[itemId]]
	if currentState && currentState.visibleAndColliding:
		if sprite:
			sprite.texture = currentState.texture
			print("set new texture for " + id)
		if collider:
			collider.shape = currentState.colliderShape
			print("set new collider for " + id)
	if dependsOnOther:
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
	var rot: float
	var visibleAndColliding: bool
	var texture: Texture2D
	var colliderShape: Shape2D
	var itemToReturnOnTransition: Item
	var interactionTransitions: Dictionary[String, String] ## ItemId mapped to own TimeobjectStateId
	var otherTimeobjects: Array[String] ## TimeobjectIDs that this Timeobject's state depends on
	var cascadeTransitions: Dictionary[String, String] ## notifierStateId mapped to own TimeobjectStateId
	
	func _init(id: String, pos: Vector2, rot: float, vis: bool, texPath: String, col: Shape2D, itemPath: String) -> void:
		self.id = id
		self.pos = pos
		self.rot = rot
		self.visibleAndColliding = vis
		self.texture = load(texPath) if texPath != "" else null
		self.colliderShape = col
		self.itemToReturnOnTransition = load(itemPath) if itemPath != "" else null
		self.interactionTransitions = {}
		self.otherTimeobjects = []
		self.cascadeTransitions = {}
	
	func addInteractionTransition(itemId: String, stateId: String):
		self.interactionTransitions.set(itemId, stateId)
	
	func addCascadeTransition(notifierId: String, notifierStateId: String, ownStateId: String):
		self.otherTimeobjects.push_back(notifierId)
		self.cascadeTransitions.set(notifierStateId, ownStateId)
