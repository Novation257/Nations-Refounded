extends Camera2D

func _input(event):
	if event is InputEventPanGesture:
		print("scrolled: " + str(event.delta.y))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_movement_starting_pos: Vector2
	
	if Input.is_action_pressed("ScrollUp"):
		print("ScrollUp")
		zoom[0] *= 1.03
		zoom[1] *= 1.03
	if Input.is_action_pressed("ScrollDown"):
		print("ScrollDown")
		zoom[0] *= .97
		zoom[1] *= .97
	if Input.is_action_just_pressed("RMB"):
		mouse_movement_starting_pos = get_global_mouse_position()
		
		
	pass
