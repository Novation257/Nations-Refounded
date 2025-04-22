extends CanvasLayer
class_name StaticUI

# Nodes
@onready var buildMenu:ScrollContainer = get_node("BuildMenu")
@onready var buildButton:Button = get_node("%BuildMenu Toggle")
@onready var BMVContainer:VBoxContainer = get_node("BuildMenu/BMVContainer")

# Panels
var extractorPanels:Array[extractorBuildButton]

# Displays a message on screen that disappears after 5 seconds
func notify(message:String) -> void:
	var panel := Panel.new()

	# Add label that contains the message
	var label := Label.new()
	panel.add_child(label)
	label.text = message
	label.size = Vector2(200, 25)
	label.position = Vector2(5, 2.5)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Add timer that deletes the message
	var timer := Timer.new()
	panel.add_child(timer)
	timer.connect("timeout", panel.queue_free)
	
	# Set panel variables and start timer
	self.add_child(panel)
	panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	panel.position = Vector2(5, get_viewport().size.y - 59)
	panel.size = Vector2(210, 31)
	panel.scale = Vector2(1.5, 1.5)
	timer.start(5)
	return

func toggleBuildMenu() -> void:
	buildMenu.visible = !buildMenu.visible
	if(buildMenu.visible == true): buildButton.text = "Close"
	else: buildButton.text = "Build"
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
	pass

func _on_build_menu_toggle_pressed() -> void:
	toggleBuildMenu()
