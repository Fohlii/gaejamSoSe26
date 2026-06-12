class_name TimeobjectManager extends Node
@export var timeobjectsById: Dictionary[String, Timeobject]

func start() -> void:
	print(timeobjectsById.values())
	for to in timeobjectsById.values():
		to.initializeAfterReadyStepTwo()
