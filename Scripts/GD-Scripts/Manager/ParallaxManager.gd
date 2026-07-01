class_name ParallaxManager extends Node

@onready var parallax_node: Parallax2D = $FarthestBackgroundLayer

func transition_parallax_scale(player: Node2D, new_scale: float) -> void:
	
	var camera_x: float = player.global_position.x
	var old_scale: float = parallax_node.scroll_scale.x
	var old_offset: float = parallax_node.scroll_offset.x
	
	var half_screen_width: float = get_viewport().get_visible_rect().size.x * 0.5
	var calculated_offset: float = old_offset + (camera_x - half_screen_width) * (new_scale - old_scale)
	
	# Apply changes simultaneously
	parallax_node.scroll_scale = Vector2(new_scale, parallax_node.scroll_scale.y)
	parallax_node.scroll_offset.x = calculated_offset
