class_name ParallaxManager extends Node

@onready var parallaxNodes: Array[Parallax2D] = [$BackgroundLayer, $FarLayer, $NearLayer, $FrontLayer]

func transition_parallax_scale(player: Node2D, new_scale: float, weights: Array[float] = []) -> void:
	if weights.size() == 0:
		weights.push_back(1.0)
	var weightsIndex: int = 0
	for parallaxNode in parallaxNodes:
		var camera_x: float = player.global_position.x
		var old_scale: float = parallaxNode.scroll_scale.x
		var old_offset: float = parallaxNode.scroll_offset.x
		
		var half_screen_width: float = get_viewport().get_visible_rect().size.x * 0.5
		var calculated_offset: float = old_offset + (camera_x - half_screen_width) * (new_scale - old_scale) * weights[weightsIndex]
		
		# Apply changes simultaneously
		parallaxNode.scroll_scale = Vector2(new_scale * weights[weightsIndex], parallaxNode.scroll_scale.y)
		parallaxNode.scroll_offset.x = calculated_offset
		
		if (weightsIndex + 1) < weights.size():
			weightsIndex += 1
