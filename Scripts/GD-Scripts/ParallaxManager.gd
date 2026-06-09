class_name ParallaxManager extends Node

@onready var parallax_node: Parallax2D = $FarthestBackgroundLayer
var camera: Camera2D

func transition_parallax_scale(new_scale: float) -> void:
	camera = get_viewport().get_camera_2d()
	if not parallax_node or not camera:
		return
		
	var camera_x: float = camera.global_position.x
	var old_scale: float = parallax_node.scroll_scale.x
	var old_offset: float = parallax_node.scroll_offset.x
	
	var calculated_offset: float = old_offset + camera_x * (new_scale - old_scale)
	
	parallax_node.scroll_scale = Vector2(new_scale, parallax_node.scroll_scale.y)
	parallax_node.scroll_offset.x = calculated_offset
