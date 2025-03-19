extends Camera2D

var zoom_sensitivity:float = .1
var zoom_limits:Vector2 = Vector2(.75,5)
var mouse_starting_pos: Vector2 = Vector2(0,0)
var camera_starting_pos: Vector2 = Vector2(0,0)

# Changes zoom based on sensitivity and direction
# Will keep zoom's value between specified limits
func change_zoom(direction:int) -> void:
	zoom[0] *= 1+ (direction*zoom_sensitivity)
	zoom[0] = max(zoom_limits[0], zoom[0])
	zoom[0] = min(zoom_limits[1], zoom[0])
	zoom[1] = zoom[0]

# Handles scroll wheel inputs
func _input(event):
	# Mouse inputs
	if event is InputEventMouseButton:
		# Scroll Up - zoom in
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_zoom(1)
		# Scrol Down - zoom out
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_zoom(-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Camera movement via mouse
	# At start of click, get mouse and camera position
	if Input.is_action_just_pressed("LMB"):
		camera_starting_pos = position
		mouse_starting_pos = get_viewport().get_mouse_position()
		print(mouse_starting_pos)
	# Update camera position based on mouse movement while clicked
	elif Input.is_action_pressed("LMB"):
		var mouse_curr_pos = get_viewport().get_mouse_position()
		position = camera_starting_pos - (1/zoom[0])*(mouse_curr_pos - mouse_starting_pos)
	
	# Camera movement via arrow keys
	position += Input.get_vector("CamLeft", "CamRight", "CamUp", "CamDown").normalized() * (7.5 * 1/zoom[0])
	
		
	pass
