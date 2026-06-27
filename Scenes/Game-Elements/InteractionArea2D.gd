class_name InteractionArea2D extends Area2D

@onready var collider: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collider.shape = CircleShape2D.new()
	collider.shape.set_radius(20.0)
	set_collision_layer_value(2, true)
	monitoring = false
	monitorable = true
