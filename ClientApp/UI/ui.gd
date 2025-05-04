extends CanvasLayer
class_name StaticUI

# Nodes
@onready var buildMenu:ScrollContainer = get_node("BuildMenu")
@onready var buildButton:Button = get_node("%BuildMenu Toggle")
@onready var BMVContainer:VBoxContainer = get_node("BuildMenu/BMVContainer")

# Panels
var extractorPanels:Array[extractorBuildButton]
@onready var cityBuildMenu:cityBuildButton = get_node("%CityBuildMenu")

# Displays a message on screen that disappears after 5 seconds
func notify(message:String) -> void:
	# Create new panel
	var panel := Panel.new()

	# Add label that contains the message
	var label := Label.new()
	panel.add_child(label)
	label.text = message
	label.size = Vector2(250, 25)
	label.position = Vector2(5, 2.5)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Add timer that deletes the message
	var timer := Timer.new()
	panel.add_child(timer)
	timer.connect("timeout", panel.queue_free)
	
		# Move all other notifications up
	var master_children := get_children()
	for node in master_children:
		if node.get_meta("isNotif") == true:
			node.position.y -= ceil(1.5*(label.size.y + 6))
	
	# Set panel variables and start timer
	self.add_child(panel)
	panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	panel.position = Vector2(5, get_viewport().size.y - 59)
	panel.size = Vector2(label.size.x + 10, label.size.y + 6)
	panel.scale = Vector2(1.5, 1.5)
	panel.set_meta("isNotif", true)
	timer.start(5)
	return

func toggleBuildMenu() -> void:
	buildMenu.visible = !buildMenu.visible
	if(buildMenu.visible == true):
		buildButton.text = "Close"
		if(cityBuildMenu.panel.visible == true): toggleCityMenu()
	else: buildButton.text = "Build"
	pass

func toggleCityMenu() -> void:
	cityBuildMenu.panel.visible = !cityBuildMenu.panel.visible
	if(cityBuildMenu.panel.visible == true): 
		cityBuildMenu.menuToggle.text = "Close"
		if(buildMenu.visible == true): toggleBuildMenu()
	else: cityBuildMenu.menuToggle.text = "City"
	pass

func _ready() -> void:
	# Build list of buildables
	var allExtractors:Array[ExtractorType] = ExtractorType.new().all()
	var lastNode:Node = BMVContainer
	for extractor in allExtractors:
		# Load extractor UI and instanciate
		var newExBtnRes:Resource = load("res://UI/extractorBuildButton/ExtractorBuildButton.tscn")
		var newExBtn:extractorBuildButton = newExBtnRes.instantiate()
		lastNode.add_child(newExBtn)
		newExBtn.setStats(extractor)
		newExBtn.position.y = 230 # ~ 5px spacing between list items
		lastNode = newExBtn
		extractorPanels.append(newExBtn)
	
	BMVContainer.custom_minimum_size.y = allExtractors.size() * 230
	
	cityBuildMenu.menu_toggle_pressed.connect(_on_city_menu_toggle_pressed)
	pass

func _on_build_menu_toggle_pressed() -> void:
	toggleBuildMenu()

func _on_city_menu_toggle_pressed() -> void:
	toggleCityMenu()
