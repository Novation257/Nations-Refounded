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

var staticUI:StaticUI
var buildMenu:ScrollContainer

# Process flags
var placingExtractor:bool = false

func placeRecourceExtractor(type:String) -> void:
	# Load extractor UI and instanciate
	var newUIRes:Resource = load("res://gameObjects/extractor/ExtractorPlacementUI.tscn")
	var placementUI = newUIRes.instantiate()
	placementUI.position = get_global_mouse_position()
	get_node(".").add_child(placementUI)
	placementUI.setType(type)
	
	# Connect signal
	placementUI.ready_to_place.connect(_on_extractor_placed)
	pass

# Check if any extractor was clicked and attempt to collect resources
func check_extractor_collection(extractors:Array[Node]) -> void:
	for extractor in extractors:
		# If the clicked extractor is owned by the current player
		if extractor.clicked == true && extractor.get_meta("ownerID") == curr_player.id:
			# If there are no resources in the extractor...
			if extractor.stockpile == 0: print(extractor.name + " has no resources to collect")
			# If the player has the resources to collect...
			elif curr_player.resources.canCombine(extractor.get_stored()):
				print("Collected resources from " + extractor.name)
				extractor.get_stored().print()
				curr_player.resources.combine(extractor.collect())
			else:
				print("Not enough resources to collect from " + extractor.name)
				extractor.get_stored().print()

func update_build_buttons() -> void:
	for extractorPanel:extractorBuildButton in staticUI.extractorPanels:
		var cost:Resources = Resources.new()
		cost.combine(extractorPanel.buildable.constructionCost)
		cost.negate()
		if(curr_player.resources.canCombine(cost)):
			extractorPanel.buildButton.text = "Build"
			extractorPanel.buildButton.disabled = false
		else:
			extractorPanel.buildButton.text = "Insufficient Materials"
			extractorPanel.buildButton.disabled = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize player
	curr_player = Player.new()
	curr_player.id = 1
	curr_player.resources.money = 10000
	curr_player.resources.food = 5000
	curr_player.resources.building_materials = 1000
	
	# Get UI nodes
	moneyUI = get_node("%camera+static ui/%Money Number")
	foodUI = get_node("%camera+static ui/%Food Number")
	energyUI = get_node("%camera+static ui/%Energy Number")
	BMUI = get_node("%camera+static ui/%BM Number")
	CGUI = get_node("%camera+static ui/%CG Number")
	CompositesUI = get_node("%camera+static ui/%Composites Number")
	
	staticUI = get_node("%camera+static ui/%UI")
	buildMenu = staticUI.get_node("%BuildMenu")
	
	# Connect all signals from child nodes to this script
	for rn in get_node("%Res Nodes").get_children():
		rn.node_clicked.connect(_on_res_node_clicked)
	
	for extractorPanel:extractorBuildButton in staticUI.extractorPanels:
		extractorPanel.build_button_clicked.connect(_on_build_button_pressed)
	
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
		#print(time)
		
		# Update extractors
		for extractor in extractors:
			extractor.doProductionTick(360)
	
	# Extractor clicked - collect stockpiled resources
	check_extractor_collection(extractors)
	
	# Update build menu
	update_build_buttons()
	
	# Run input routines if button is pressed
	if Input.is_action_just_pressed("debug1"):
		placeRecourceExtractor("Rice Farm")
	if Input.is_action_just_pressed("debug2"):
		placeRecourceExtractor("Wind Turbine")
	if Input.is_action_just_pressed("debug3"):
		placeRecourceExtractor("Dairy Farm")
	if Input.is_action_just_pressed("BuildMenuToggle"):
		staticUI.toggleBuildMenu()
	
	# Update UI
	update_ui()

func _on_extractor_placed(extractor_position:Vector2, type:String) -> void:
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
	
	# Subtract extractor construction cost from the player's resources
	curr_player.resources.combine(newEx.exStats.constructionCost.negate())
	pass

func _on_res_node_clicked(extractor:String) -> void:
	placeRecourceExtractor(extractor)

func _on_build_button_pressed(extractor:String) -> void:
	buildMenu.visible = false
	placeRecourceExtractor(extractor)
