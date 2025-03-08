extends Polygon2D

#UI
var UI:Panel
var UI_ownerID:Label
var UI_type:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait for variable and metadata updates from main script
	
	UI = get_node("%UI")
	UI.visible = false
	
	UI_ownerID = get_node("%ownerID")
	UI_ownerID.text = "OwnerID: " + str(get_meta("ownerID"))
	
	UI_type = get_node("%type")
	UI_type.text = get_meta("type")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if UI.visible == true:
		var m_pos:Vector2 = get_local_mouse_position()
		UI.position[0] = m_pos[0] + 2
		UI.position[1] = m_pos[1] + 2
	
	pass


func _on_area_2d_mouse_entered() -> void:
	UI.visible = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	UI.visible = false
	pass # Replace with function body.
