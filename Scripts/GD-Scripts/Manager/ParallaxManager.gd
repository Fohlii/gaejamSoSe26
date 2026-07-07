class_name ParallaxManager extends Node

@onready var parallaxNodes: Array[Parallax2D] = [$FarthestBackLayer]

func transition_parallax_scale(player: Node2D, new_scale: float) -> void:
	for parallaxNode in parallaxNodes:
		print("scroll scale changed to ", new_scale)
		var camera_x: float = player.global_position.x
		var old_scale: float = parallaxNode.scroll_scale.x
		var old_offset: float = parallaxNode.scroll_offset.x
		
		var half_screen_width: float = get_viewport().get_visible_rect().size.x * 0.5
		var calculated_offset: float = old_offset + (camera_x - half_screen_width) * (new_scale - old_scale)
		
		# Apply changes simultaneously
		parallaxNode.scroll_scale = Vector2(new_scale, parallaxNode.scroll_scale.y)
		parallaxNode.scroll_offset.x = calculated_offset
	
