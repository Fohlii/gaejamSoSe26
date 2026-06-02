class_name PlayerCharacterBody2D extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var left_foot: AudioStreamPlayer2D = $left_foot
@onready var right_foot: AudioStreamPlayer2D = $right_foot
var SPEED = 200.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		sprite_2d.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if Input.is_action_pressed("run"):
			SPEED = 400.0
		else:
			SPEED = 200.0
		if sprite_2d.animation != "walk":
			sprite_2d.play("walk")
		velocity.x = direction * SPEED
		if direction < 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h= false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite_2d.play("default")

	move_and_slide()

func _on_sprite_2d_frame_changed() -> void:
	if sprite_2d.frame == 2:
		left_foot.play()
	elif sprite_2d.frame == 5:
		right_foot.play()
