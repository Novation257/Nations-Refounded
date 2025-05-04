extends Control
class_name cityBuildButton

# Nodes
@onready var panel:Panel = get_node("Panel")
@onready var nameLabel:Label = get_node("Panel/ExtractorName")
@onready var constructionLabel:Label = get_node("Panel/ConstructionCost/ConstructionMats")
@onready var regionLabel:Label = get_node("Panel/ReqRegion")
@onready var buildButton:Button = get_node("Panel/BuildButton")
@onready var menuToggle:Button = get_node("BuildMenu Toggle")
@onready var nameInput:LineEdit = get_node("%CityNameInput")

var tempCity := City.new()
var constructionCost := Resources.new()

signal build_button_clicked()
signal menu_toggle_pressed()

func _ready() -> void:
	constructionCost.money = tempCity.cc_money
	constructionCost.food = tempCity.cc_food
	constructionCost.building_materials = tempCity.cc_building_materials
	tempCity.queue_free()

func _on_build_button_pressed() -> void:
	print("Clicked " + name)
	build_button_clicked.emit()
	pass # Replace with function body.

func _on_build_menu_toggle_pressed() -> void:
	menu_toggle_pressed.emit()
	pass # Replace with function body.
