extends Node

signal changed
@onready var count: Label = $PanelContainer/MarginContainer/VBoxContainer/SlotGrid/InventorySlot/Count

const SLOT_COUNT := 20

var slots: Array = []


func add_item(item,itemTexture: Texture2D, amount: int = 1) -> bool:
	var remaining := amount
	if item:
		count.text = item.id
	# Erst vorhandene Stacks auffüllen
		for slot in slots:
			if slot["item"] == item and slot["amount"] < item.max_stack:
				var free_space: int = item.max_stack - slot["amount"]
				var to_add: int = min(free_space, remaining)

				slot["amount"] += to_add
				remaining -= to_add

				if remaining <= 0:
					changed.emit()
					return true

	# Dann leere Slots benutzen
		for slot in slots:
			if slot["item"] == null:
				var to_add: int = min(item.max_stack, remaining)

				slot["item"] = item
				slot["amount"] = to_add
				remaining -= to_add

				if remaining <= 0:
					changed.emit()
					return true

	changed.emit()
	return false


func remove_from_slot(index: int, amount: int = 1) -> void:
	if index < 0 or index >= slots.size():
		return

	var slot = slots[index]

	if slot["item"] == null:
		return

	slot["amount"] -= amount

	if slot["amount"] <= 0:
		slot["item"] = null
		slot["amount"] = 0

	changed.emit()


func swap_slots(index_a: int, index_b: int) -> void:
	if index_a == index_b:
		return

	if index_a < 0 or index_a >= slots.size():
		return

	if index_b < 0 or index_b >= slots.size():
		return

	var temp = slots[index_a]
	slots[index_a] = slots[index_b]
	slots[index_b] = temp

	changed.emit()
