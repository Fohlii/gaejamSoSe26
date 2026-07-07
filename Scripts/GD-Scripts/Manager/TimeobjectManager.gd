class_name TimeobjectManager extends RefCounted

## All Timeobjects in Past and Present
var timeobjectsById: Dictionary[String, Timeobject]

func initializeTimeobjects(tree: SceneTree) -> void:
	for to in tree.get_nodes_in_group("Timeobjects"):
		timeobjectsById[to.id] = to
	for to in timeobjectsById.values():
		to.registerListeners()
		to.updateTransform()
		to.updateTextureAndCollider()
