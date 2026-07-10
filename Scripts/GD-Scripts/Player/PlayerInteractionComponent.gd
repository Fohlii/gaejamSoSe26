class_name PlayerInteractionComponent extends PlayerComponent
var playerInteractionArea: Area2D
var playerInventoryUI: Node
var playerInventoryItem: Item

func _init(player: PlayerCharacterBody2D) -> void:
	super(player)
	playerInteractionArea = player.interactionArea
	playerInventoryUI = player.get_tree().current_scene.get_node_or_null("UI/InventoryOverlay/Inventory")
	playerInventoryItem = null

func processInput(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if !playerInteractionArea.get_overlapping_areas().is_empty():
			## Level Design Choice: Interactables should be spread far enough apart to make [0] unambiguous
			_playerInteract(playerInteractionArea.get_overlapping_areas()[0].get_parent())

func _playerInteract(interactable: Interactable):
	playerInventoryItem = interactable.interact(playerInventoryItem)
	playerInventoryUI.add_item(playerInventoryItem)
