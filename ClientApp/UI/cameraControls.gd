extends Camera2D

var zoom_target := zoom[0]
var zoom_sensitivity:float = .1
var zoom_limits:Vector2 = Vector2(.75,5)
var mouse_starting_pos: Vector2 = Vector2(0,0)
var camera_starting_pos: Vector2 = Vector2(0,0)

var old_mpos := Vector2(0,0)
var new_mpos := Vector2(0,0)

# Changes zoom based on sensitivity and direction
# Will keep zoom's value between specified limits
func change_zoom(direction:int) -> void:
	zoom_target *= 1 + (direction*zoom_sensitivity)
	zoom_target = max(zoom_limits[0], zoom_target)
	zoom_target = min(zoom_limits[1], zoom_target)

# Handles scroll wheel inputs
func _input(event):
	# Mouse inputs
	if event is InputEventMouseButton:
		# Scroll Up - zoom in
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && !Input.is_action_pressed("Shift"): # TODO: change this in release version - hotfix for UI scroll lock for demo
			change_zoom(1)
		# Scroll Down - zoom out
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN && !Input.is_action_pressed("Shift"):
			change_zoom(-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	new_mpos = get_global_mouse_position()
	
	# Zoom smoothing
	zoom = lerp(zoom, Vector2(zoom_target, zoom_target), .175)
	
	# Camera movement via arrow keys
	position += Input.get_vector("CamLeft", "CamRight", "CamUp", "CamDown").normalized() * (30 * 1/zoom[0])
	
	# Camera movement via mouse
	# At start of click, get mouse and camera position
	if Input.is_action_just_pressed("LMB"):
		camera_starting_pos = position
		mouse_starting_pos = get_viewport().get_mouse_position()
	# Update camera position based on mouse movement while clicked
	elif Input.is_action_pressed("LMB"):
		var mouse_curr_pos = get_viewport().get_mouse_position()
		position = camera_starting_pos - (1/zoom[0])*(mouse_curr_pos - mouse_starting_pos)
	
	if(abs(zoom[0] - zoom_target) > .05):
		position += (old_mpos - new_mpos) * (3 + abs(zoom[0] - zoom_target))
		pass
	
	old_mpos = new_mpos
	
	position.x = max(limit_left, min(limit_right, position.x))
	position.y = max(limit_top, min(limit_bottom, position.y))
	print(position)
	return

func _on_build_menu_focus_entered() -> void:
	print("entered")
	pass # Replace with function body.
