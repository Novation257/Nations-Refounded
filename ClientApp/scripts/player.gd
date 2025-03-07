class_name Player

# Identifiers
var name:String
var id:int

# Resources
var money:int = 0
var food:int = 0
var energy:int = 0
var building_materials:int = 0
var composites:int = 0
var consumer_goods:int = 0

# Owned game objects
var units:Array
var cities:Array
var extractors:Array

func _init() -> void:
	print("init'd")
	pass

# DEBUG - check if the script was initialized
func checkInit():
	print("RoomGen initialized successfully")
	pass
