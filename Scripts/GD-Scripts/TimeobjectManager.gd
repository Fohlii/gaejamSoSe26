class_name TimeobjectManager extends Node
@export var timeobjectsById: Dictionary[String, Timeobject]

func _ready() -> void:
	for to in timeobjectsById.values():
		to.initializeAfterReadyStepOne()
	for to in timeobjectsById.values():
		to.initializeAfterReadyStepTwo()
