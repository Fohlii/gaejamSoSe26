class_name ParallaxEnterTrigger extends Area2D

@onready var parallaxManager: ParallaxManager = $"../../.."

@export var zoneScrollScale: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true
	monitorable = false
	set_collision_mask_value(1, true)
	body_entered.connect(parallaxManager.transition_parallax_scale.bind(zoneScrollScale))
