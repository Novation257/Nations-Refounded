class_name Player

# Identifiers
var name:String
var id:int

# Resources
var resources:Resources = Resources.new()

# Owned game objects
var units:Array
var cities:Array
var extractors:Array

func _init() -> void:
	pass

# DEBUG - check if the script was initialized
func checkInit():
	print("initialized successfully")
	pass
