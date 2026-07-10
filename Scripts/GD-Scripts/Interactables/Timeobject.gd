@abstract class_name Timeobject extends Interactable
## A Timeobject is any instantiable in past or present that changes directly due to player action
## or indirectly through player action on other Timeobjects

## All possible states for this Timeobject
var _statesById: Dictionary[String, TimeobjectState]
## The currently active state of this Timeobject
var _currentState: TimeobjectState

## TimeobjectIDs that this Timeobject's state depends on
var _observedTimeobjects: Array[String]

signal timeobject_state_changed_event(notifierId: String, notifierNewStateId: String)

func _ready() -> void:
	super()
	add_to_group("Timeobjects", true)

## Whether this Timeobject depends on a state-change of another Timeobject
func observesOther() -> bool:
	return _observedTimeobjects.is_empty()

## Register this Timeobject's dependencies on state-changes of other Timeobjects
func registerListeners() -> void:
	for notifierId in _observedTimeobjects:
		get_tree().current_scene.timeobjectManager.timeobjectsById[notifierId].timeobject_state_changed_event.connect(self.on_other_timeobject_state_changed)
		print(self.id + " registered listener for " + notifierId)

func updateTransform() -> void:
	self.position = _currentState.pos
	self.rotation = _currentState.rot
	self.scale = Vector2.ONE * _currentState.sca

func updateTextureAndCollider() -> void:
	_sprite.texture = _currentState.texture
	_sprite.offset = _currentState.spriteOffset
	_collider.polygon = _currentState.colliderPolygon

## What happens when the player tries to interact with this Node. Note: return can be null if the item is consumed.
func interact(item: Item) -> Item:
	var inventory_overlay = get_tree().current_scene.get_node_or_null("UI/InventoryOverlay/Inventory")
	if !item && _currentState.interactionTransitions.keys().has("EMPTY_HAND"):
		_interactionTransition("EMPTY_HAND")
		print(item)
		if item != null:	
			if item.textureInInventory != null:
				inventory_overlay.add_item(item)		
			if item.textureOnCharacter != null:
				inventory_overlay.add_item(item)
		else:
			inventory_overlay.add_item(self)
		return _currentState.itemToReturnOnTransition
	elif item && _currentState.interactionTransitions.keys().has(item.id):
		_interactionTransition(item.id)
		inventory_overlay.remove_item()
		print(item.textureInInventory)
		return _currentState.itemToReturnOnTransition
	else:
		return item # return item if not used and interactable doesn't specify that it shouldn't be returned

## handles state change events of observed timeobjects
func on_other_timeobject_state_changed(notifierId: String, notifierStateId: String) -> void:
	if _currentState.cascadeTransitions.keys().has(notifierStateId):
		_cascadeTransition(_currentState.cascadeTransitions[notifierStateId])

func _interactionTransition(itemId: String) -> void:
	_cascadeTransition(_currentState.interactionTransitions[itemId])

func _cascadeTransition(newStateId: String) -> void:
	_currentState = _statesById[newStateId]
	updateTransform()
	updateTextureAndCollider()
	timeobject_state_changed_event.emit(id, _currentState.id)

class TimeobjectState extends Resource:
	var id: String
	
	var pos: Vector2
	var rot: float
	var sca: float
	
	var texture: Texture2D
	var spriteOffset: Vector2
	var colliderPolygon: PackedVector2Array
	
	var itemToReturnOnTransition: Item ## Can be null
	var interactionTransitions: Dictionary[String, String] ## ItemId mapped to own TimeobjectStateId
	var cascadeTransitions: Dictionary[String, String] ## notifierStateId mapped to own TimeobjectStateId
	
	func _init(id: String, pos: Vector2 = Vector2.ZERO, rot: float = 0, sca: float = 1.0, texPath: String = "", sprOff: Vector2 = Vector2.ZERO, col: Array[Vector2] = [], itemPath: String = "") -> void:
		self.id = id
		self.pos = pos
		self.rot = rot
		self.sca = sca
		self.texture = load("res://Assets/Timeobjects/Textures/" + texPath) if texPath != "" else null
		self.spriteOffset = sprOff
		self.colliderPolygon = PackedVector2Array(col)
		self.itemToReturnOnTransition = load("res://Resources/Items/" + itemPath) if itemPath != "" else null
		self.interactionTransitions = {}
		self.cascadeTransitions = {}
	
	func setPosition(pos: Vector2 = Vector2.ZERO) -> TimeobjectState:
		self.pos = pos
		return self
	
	func setRotation(rot: float = 0) -> TimeobjectState:
		self.rot = rot
		return self
	
	func setScale(sca: float = 1.0) -> TimeobjectState:
		self.sca = sca
		return self
	
	func setTexture(texPath: String = "") -> TimeobjectState:
		self.texture = load("res://Assets/Timeobjects/Textures/" + texPath) if texPath != "" else null
		return self
	
	func setSpriteOffset(sprOff: Vector2 = Vector2.ZERO) -> TimeobjectState:
		self.spriteOffset = sprOff
		return self
	
	func setColliderPolygon(col: Array[Vector2] = []) -> TimeobjectState:
		self.colliderPolygon = PackedVector2Array(col)
		return self
	
	func setItem(itemPath: String = "") -> TimeobjectState:
		print(itemPath)
		self.itemToReturnOnTransition = load("res://Resources/Items/" + itemPath) if itemPath != "" else null
		return self
	
	func addInteractionTransition(itemId: String, stateId: String):
		self.interactionTransitions.set(itemId, stateId)
	
	func addCascadeTransition(notifierStateId: String, ownStateId: String):
		self.cascadeTransitions.set(notifierStateId, ownStateId)
