extends CanvasLayer
class_name StaticUI

# Nodes
var buildMenu:ScrollContainer
var buildButton:Button
var BMVContainer:VBoxContainer

# Panels
var extractorPanels:Array[extractorBuildButton]

func toggleBuildMenu() -> void:
	buildMenu.visible = !buildMenu.visible
	if(buildMenu.visible == true): buildButton.text = "Close"
	else: buildButton.text = "Build"
	pass

func _ready() -> void:
	buildMenu = get_node("BuildMenu")
	buildButton = get_node("%BuildMenu Toggle")
	BMVContainer = get_node("BuildMenu/BMVContainer")
	
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
