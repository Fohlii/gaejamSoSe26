extends Area2D

@export var zoneIndex: int
@onready var parallaxManager: ParallaxManager = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if zoneIndex && parallaxManager:
		body_entered.connect(parallaxManager.switch_to_zone.bind(zoneIndex))
