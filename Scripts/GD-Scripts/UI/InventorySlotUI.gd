extends Panel

@onready var icon: TextureRect = %Icon
@onready var count_label: Label = %Count

var slot_index: int = -1


func _ready() -> void:
	custom_minimum_size = Vector2(64, 64)

	icon.anchor_left = 0
	icon.anchor_top = 0
	icon.anchor_right = 1
	icon.anchor_bottom = 1
	icon.offset_left = 0
	icon.offset_top = 0
	icon.offset_right = 0
	icon.offset_bottom = 0

	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED


func _setSlot(index: int, slot_data: Texture2D) -> void:
	slot_index = index

	var item: Texture2D = slot_data

	print("item: ", item)
	print("icon size: ", icon.size)
	print("slot size: ", size)

	if item == null:
		icon.texture = null
	else:
		icon.texture = item
