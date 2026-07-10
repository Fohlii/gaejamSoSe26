extends Control
@onready var inventory_slot: Panel = $InventorySlot
@onready var icon: TextureRect = $InventorySlot/Icon
@onready var count: Label = $InventorySlot/Count



func add_item(item: Item) -> void:
	if item == null:
		remove_item()
		return

	if item.id:
		count.text = item.id
	else:
		count.text = "no item"

	if item.textureInInventory:
		icon.texture = item.textureInInventory
	else:
		icon.texture = load("res://Assets/Timeobjects/Textures/icon.svg")


func remove_item() -> void:
	count.text = ""
	icon.texture = null
