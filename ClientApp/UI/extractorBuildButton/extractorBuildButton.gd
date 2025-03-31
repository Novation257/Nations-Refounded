extends Control
class_name extractorBuildButton

# Nodes
var nameLabel:Label
var consumptionLabel:Label
var productionLabel:Label
var constructionLabel:Label
var regionLabel:Label
var resNodeLabel:Label
var buildButton:Button

var buildable:ExtractorType

signal build_button_clicked(extractorType:String)

# Builds the string to print out the contents of a resources class
func buildResourceString(delimiter:String, resources:Resources) -> String:
	var returnString = ""
	if (resources.money != 0): returnString += "Money:  " + str(resources.money) + delimiter
	if (resources.food != 0): returnString += "Food:  " + str(resources.food) + delimiter
	if (resources.energy != 0): returnString += "Energy:  " + str(resources.energy) + delimiter
	if (resources.building_materials != 0): returnString += "Building Materials:  " + str(resources.building_materials) + delimiter
	if (resources.consumer_goods != 0): returnString += "Consumer Goods:  " + str(resources.consumer_goods) + delimiter
	if (resources.composites != 0): returnString += "Composites:  " + str(resources.composites) + delimiter
	
	return returnString 

# Get child nodes on ready
func _ready() -> void:
	nameLabel = get_node("Panel/ExtractorName")
	consumptionLabel = get_node("Panel/Consumption/ConsumptionMats")
	productionLabel = get_node("Panel/Production/ProductionMats")
	constructionLabel = get_node("Panel/ConstructionCost/ConstructionMats")
	regionLabel = get_node("Panel/ReqRegion")
	resNodeLabel = get_node("Panel/ReqNode")
	buildButton = get_node("Panel/BuildButton")


func setStats(extractorStats:ExtractorType) -> void:
	buildable = extractorStats
	
	# Production, Consumption, and Construction resources
	nameLabel.text = extractorStats.typeName
	consumptionLabel.text = buildResourceString("     ", extractorStats.inputs)
	productionLabel.text = buildResourceString("     ", extractorStats.outputs)
	constructionLabel.text = buildResourceString("\n", extractorStats.constructionCost)
	
	# Region and Res node
	var regionString:String = extractorStats.constructionRegion
	regionString[0] = regionString.to_upper()[0]
	regionLabel.text = "Required Region: " + regionString
	
	resNodeLabel.text = "Required Node:    "
	if (extractorStats.constructionResNode != ""): resNodeLabel.text += extractorStats.constructionResNode
	else: resNodeLabel.text += "None"
	
	return


func _on_build_button_pressed() -> void:
	print("Clicked " + name)
	build_button_clicked.emit(buildable.typeName)
	pass # Replace with function body.
