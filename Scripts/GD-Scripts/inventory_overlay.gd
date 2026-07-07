extends Control

@export var slot_scene: PackedScene 
@onready var slot_grid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/SlotGrid


func _ready() -> void:

	Inventory.changed.connect(_refresh)

	_create_slots()
	_refresh()


func _create_slots() -> void:
	for child in slot_grid.get_children():
		child.queue_free()

	for i in range(Inventory.slots.size()):
		var slot_ui = slot_scene.instantiate()
		slot_grid.add_child(slot_ui)


func _refresh() -> void:
	for i in range(Inventory.slots.size()):
		var slot_ui = slot_grid.get_child(i)
		slot_ui._setSlot(i, Inventory.slots[i])
