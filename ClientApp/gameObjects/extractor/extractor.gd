extends Polygon2D
class_name Extractor

# Identifiers
var id:int

# UI
@onready var Camera:Camera2D = get_parent().get_parent().get_node("%camera+static ui")
@onready var UI:Panel = get_node("%UI")
@onready var UI_type:Label = get_node("%type")
@onready var UI_ownerID:Label = get_node("%ownerID")
@onready var UI_stockpile:Label = get_node("%stockpile")
@onready var UI_TTP:Label = get_node("%TTP")
@onready var UI_stockpileDisplay:Label = get_node("%stockpileDisplay")

# Signaling
var clicked:bool = false

# Extractor type
var exStats = ExtractorType.new()

# Production
var productionTime:int = 3600
var productionCountdown:int = productionTime
var stockpile:int = 0
var maxStockpile = 75
var constructionTime = 3 * productionTime

# Add production to the extractor and increase stockpile when necessary
func doProductionTick(time:int) -> void:
	if(stockpile < maxStockpile): # Don't do production if stockiple is full
		#print("Doing tick on extractor:" + name)
		productionCountdown -= time
		if(productionCountdown <= 0): # Production cycle completed
			stockpile += 1
			productionCountdown = productionTime + productionCountdown
		
		# Update UI
		UI_stockpile.text = "Stockpile: " + str(stockpile)
		UI_TTP.text = "TTP: " + str(productionCountdown)
		if(productionCountdown <= productionTime): 
			UI_stockpileDisplay.text = str(stockpile)
			UI_stockpileDisplay.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		if(stockpile == maxStockpile): UI_stockpileDisplay.add_theme_color_override("font_color", Color.RED)
	return

# Return the resources stored in the extractor without subtracting from the stockpile
func get_stored() -> Resources:
	# Combine into one resource struct with inputs being negative and outputs being positive
	var temp:Resources = Resources.new()
	temp.combine(exStats.outputs)
	var negInputs = Resources.new()
	negInputs.combine(exStats.inputs)
	negInputs.negate()
	temp.combine(negInputs)
	
	# Multiply every resource by stockpile
	temp.applyToAll(func mul(x:int): return x * stockpile)
	
	return temp

# Collect the production stored in the extractor
func collect() -> Resources:
	# Get resources stored in the extractor
	var temp:Resources = get_stored()
	
	# Reset stockpile and return resource changes
	stockpile = 0
	UI_stockpile.text = "Stockpile: " + str(stockpile)
	UI_stockpileDisplay.text = str(stockpile)
	UI_stockpileDisplay.add_theme_color_override("font_color", Color.BLACK)
	return temp

func _ready() -> void:
	# Set production values
	exStats.setType(get_meta("Type"))
	
	# Set production time to include construction time
	productionCountdown = productionTime + constructionTime
	
	# Hide UI and update values
	UI.visible = false
	UI_type.text = get_meta("Type")
	UI_ownerID.text = "OwnerID: " + str(get_meta("ownerID"))
	
	return

func _process(delta: float) -> void:
	ready
	# Make UI follow cursor if the UI isn't hidden
	if UI.visible == true:
		# Update scale
		UI.scale[0] = 1/Camera.zoom[0]
		UI.scale[1] = UI.scale[0]
		
		# Update position
		var m_pos:Vector2 = get_local_mouse_position()
		UI.position[0] = m_pos[0] + (12 * UI.scale[0])
		UI.position[1] = m_pos[1] - (0  * UI.scale[0])
	
	clicked = false
	
	return


# Show/hide UI if mouse is hoving over extractor
func _on_inherited_collision_mouse_entered() -> void:
	UI.visible = true
	return

func _on_inherited_collision_mouse_exited() -> void:
	UI.visible = false
	return


func _on_inherited_collision_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(Input.is_action_just_pressed("LMB")):
		#print(name + " clicked")
		clicked = true
	else: clicked = false
