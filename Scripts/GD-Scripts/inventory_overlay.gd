extends Control

@onready var inventory_slot: Panel = $PanelContainer/MarginContainer/InventorySlot
@onready var icon: TextureRect = $PanelContainer/MarginContainer/InventorySlot/Icon
@onready var count: Label = $PanelContainer/MarginContainer/InventorySlot/Count


func add_item(item: Item) -> void:
	if item == null:
		remove_item()
		return

	if item.id:
		count.text = str(item.id)
	else:
		count.text = "no item"

	if item.textureInInventory:
		icon.texture = item.textureInInventory
	else:
		icon.texture = load("res://Assets/Timeobjects/Textures/icon.svg")


func remove_item() -> void:
	count.text = ""
	icon.texture = null
