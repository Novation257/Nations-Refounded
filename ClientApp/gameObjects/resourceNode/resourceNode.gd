extends Node2D

var RN_name:String

# UI
var UI:Panel
var UI_name:Label

# Signal to emit when clicked
signal node_clicked(extractorType:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RN_name = get_meta("resource")
	
	UI = get_node("%UI")
	UI.visible = false
	
	UI_name = get_node("%RN_Name")
	UI_name.text = RN_name
	
	pass

func _process(delta: float) -> void:
	if UI.visible == true:
		# Update scale
		UI.scale[0] = 1/get_node("%camera+static ui").zoom[0]
		UI.scale[1] = UI.scale[0]
		
		# Update position
		var m_pos:Vector2 = get_local_mouse_position()
		UI.position[0] = m_pos[0] + (12 * UI.scale[0])
		UI.position[1] = m_pos[1] - (0 * UI.scale[0])
		
		# Emit signal if clicked
		if Input.is_action_just_pressed("LMB"):
			print("Clicked " + self.name)
			print("Emitting: " + get_meta("Extractor"))
			node_clicked.emit(get_meta("Extractor"))
	pass


func _on_area_2d_mouse_entered() -> void:
	UI.visible = true
	pass


func _on_area_2d_mouse_exited() -> void:
	UI.visible = false
	pass
