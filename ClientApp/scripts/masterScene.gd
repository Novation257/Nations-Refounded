extends Node2D

var time:int
var curr_player:Player

# UI
var moneyUI:Label
var foodUI:Label
var energyUI:Label
var BMUI:Label
var CGUI:Label
var CompositesUI:Label

func placeRecourceExtractor(type:String) -> void:
	# Load resource and instanciate
	var newExRes:Resource = load("res://gameObjects/extractor/GenericExtractor.tscn")
	var newEx = newExRes.instantiate()
	
	# Set extractor variables and metadata
	newEx.name = str(get_node("%Extractors").get_child_count(false)) + type
	newEx.set_meta("ownerID", curr_player.id)
	newEx.set_meta("type", type)
	newEx.position = get_global_mouse_position()
	
	# Add to extractors node
	get_node("%Extractors").add_child(newEx)
	
	pass




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize player
	curr_player = Player.new()
	curr_player.id = 1
	curr_player.resources.money = 1000
	curr_player.resources.food = 500
	curr_player.resources.building_materials = 100
	
	# Get UI nodes
	moneyUI = get_node("%camera+static ui/%Money Number")
	foodUI = get_node("%camera+static ui/%Food Number")
	energyUI = get_node("%camera+static ui/%Energy Number")
	BMUI = get_node("%camera+static ui/%BM Number")
	CGUI = get_node("%camera+static ui/%CG Number")
	CompositesUI = get_node("%camera+static ui/%Composites Number")
	
	return

func update_ui() -> void:
	moneyUI.text = str(curr_player.resources.money)
	foodUI.text = str(curr_player.resources.food)
	energyUI.text = str(curr_player.resources.energy)
	BMUI.text = str(curr_player.resources.building_materials)
	CGUI.text = str(curr_player.resources.consumer_goods)
	CompositesUI.text = str(curr_player.resources.composites)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var extractors = get_node("%Extractors").get_children()
	
	# Update time and time-based events
	if(time != Time.get_ticks_msec() / 1000):
		time = Time.get_ticks_msec() / 1000
		print(time)
		
		# Update extractors
		for extractor in extractors:
			extractor.doProductionTick(360)
	
	# Extractor clicked - collect stockpiled resources
	for extractor in extractors:
		if extractor.clicked == true && extractor.get_meta("ownerID") == curr_player.id:
			var resChange:Resources = extractor.collect()
			var newRes:Resources = curr_player.resources.combineNoNeg(resChange)
				
	
	# Run input routines if button is pressed
	if Input.is_action_just_pressed("debug1"):
		placeRecourceExtractor("Rice Farm")
	

	
	# Update UI
	update_ui()
