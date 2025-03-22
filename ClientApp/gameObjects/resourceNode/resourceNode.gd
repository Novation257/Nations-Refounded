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
		var m_pos:Vector2 = get_local_mouse_position()
		UI.position[0] = m_pos[0] + 10
		UI.position[1] = m_pos[1] - 35
	
		# Emit signal if clicked
		if Input.is_action_just_pressed("LMB"):
			print("Clicked " + self.name)
			node_clicked.emit(get_meta("Extractor"))
	pass


func _on_area_2d_mouse_entered() -> void:
	UI.visible = true
	pass


func _on_area_2d_mouse_exited() -> void:
	UI.visible = false
	pass
