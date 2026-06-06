class_name ParallaxManager extends Node2D

# Parallax2D nodes in exact left-to-right order
@export var parallax_chain: Array[Parallax2D] = []
# target scroll speed for each respective zone (left-to-right order)
@export var zone_scales: Array[float] = [0.5, 0.2, 0.5]

var current_zone_index: int = 0
var camera: Camera2D

func _ready() -> void:
	camera = get_viewport().get_camera_2d() ##maybe target player directly... could catch menu cam
	# Initialize everything to the first zone's scale on start
	_update_entire_chain(0)

# Call this function from Area2D trigger zones
func switch_to_zone(body: Node2D, new_zone_index: int) -> void:
	if new_zone_index == current_zone_index:
		return
		
	current_zone_index = new_zone_index
	_update_entire_chain(new_zone_index)

func _update_entire_chain(active_idx: int) -> void:
	if parallax_chain.is_empty() or not camera:
		return

	var camera_x: float = camera.global_position.x
	var new_scale: float = zone_scales[active_idx]
	
	# -----------------------------------------------------------------
	# STEP 1: Update the Primary Active Layer
	# -----------------------------------------------------------------
	var primary_layer = parallax_chain[active_idx]
	var old_scale = primary_layer.scroll_scale.x
	
	# Neutralize the camera jump for the anchor layer
	primary_layer.scroll_offset.x += camera_x * (new_scale - old_scale)
	primary_layer.scroll_scale = Vector2(new_scale, primary_layer.scroll_scale.y)
	
	# -----------------------------------------------------------------
	# STEP 2: Cascade Right (Stitch all right-adjacent layers)
	# -----------------------------------------------------------------
	for i in range(active_idx + 1, parallax_chain.size()):
		var prev_layer = parallax_chain[i - 1]
		var curr_layer = parallax_chain[i]
		
		curr_layer.scroll_scale = Vector2(new_scale, curr_layer.scroll_scale.y)
		# Right neighbor offset = Left neighbor offset + Left neighbor's physical width
		curr_layer.scroll_offset.x = prev_layer.scroll_offset.x + _get_layer_width(prev_layer)
		
	# -----------------------------------------------------------------
	# STEP 3: Cascade Left (Stitch all left-adjacent layers)
	# -----------------------------------------------------------------
	for i in range(active_idx - 1, -1, -1):
		var next_layer = parallax_chain[i + 1]
		var curr_layer = parallax_chain[i]
		
		curr_layer.scroll_scale = Vector2(new_scale, curr_layer.scroll_scale.y)
		# Left neighbor offset = Right neighbor offset - Current layer's physical width
		curr_layer.scroll_offset.x = next_layer.scroll_offset.x - _get_layer_width(curr_layer)

	# -----------------------------------------------------------------
	# STEP 4: Culling Visibility Optimization
	# -----------------------------------------------------------------
	for i in range(parallax_chain.size()):
		# Only keep the current layer and its immediate neighbors tracking
		var is_near_viewport = abs(i - active_idx) <= 1
		parallax_chain[i].visible = is_near_viewport
		parallax_chain[i].follow_viewport = is_near_viewport

# Helper function to get the actual scale-adjusted width of the Sprite2D child
func _get_layer_width(parallax: Parallax2D) -> float:
	if parallax.get_child_count() > 0:
		var sprite = parallax.get_child(0) as Sprite2D
		if sprite and sprite.texture:
			return sprite.texture.get_size().x * sprite.scale.x
	return 0.0
