extends Node2D

var RN_name:String

#UI
var UI:Panel
var UI_name:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RN_name = get_meta("resource")
	
	UI = get_node("%UI")
	UI.visible = false
	
	UI_name = get_node("%RN_Name")
	UI_name.text = RN_name
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if UI.visible == true:
		var m_pos:Vector2 = get_local_mouse_position()
		UI.position[0] = m_pos[0] + 10
		UI.position[1] = m_pos[1] - 35
	
	pass


func _on_area_2d_mouse_entered() -> void:
	UI.visible = true
	pass


func _on_area_2d_mouse_exited() -> void:
	UI.visible = false
	pass
