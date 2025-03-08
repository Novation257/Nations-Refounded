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

func place_recource_extractor(type:String) -> void:
	# Load resource and instanciate
	var newExRes:Resource = load("res://gameObjects/extractor/GenericExtractor.tscn")
	var newEx = newExRes.instantiate()
	
	# Set extractor variables and metadata
	newEx.name = type
	newEx.set_meta("ownerID", curr_player.id)
	newEx.set_meta("type", type)
	newEx.position = get_global_mouse_position()
	
	# Add to extractors node
	get_node("%Extractors").add_child(newEx)
	
	pass




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_player = Player.new()
	curr_player.id = 1
	curr_player.money = 1000
	curr_player.food = 500
	curr_player.building_materials = 100
	curr_player.checkInit()
	
	moneyUI = get_node("%camera+static ui/%Money Number")
	foodUI = get_node("%camera+static ui/%Food Number")
	energyUI = get_node("%camera+static ui/%Energy Number")
	BMUI = get_node("%camera+static ui/%BM Number")
	CGUI = get_node("%camera+static ui/%CG Number")
	CompositesUI = get_node("%camera+static ui/%Composites Number")
	

	pass # Replace with function body.

func update_ui() -> void:
	moneyUI.text = str(curr_player.money)
	foodUI.text = str(curr_player.food)
	energyUI.text = str(curr_player.energy)
	BMUI.text = str(curr_player.building_materials)
	CGUI.text = str(curr_player.consumer_goods)
	CompositesUI.text = str(curr_player.composites)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update time
	if(time != Time.get_ticks_msec() / 1000):
		time = Time.get_ticks_msec() / 1000
		print(time)
	
	# Run input routines if button is pressed
	if Input.is_action_just_pressed("debug1"):
		place_recource_extractor("Rice Farm")
	
	# Update UI
	update_ui()
