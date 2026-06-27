@abstract class_name Building extends Interactable

func interact(item: Item) -> Item:
	enter()
	return item

func enter() -> void:
	pass
