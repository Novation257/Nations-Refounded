extends Node2D

const TIMEMUL:int = 3600/4 # 1 sec = 15 min
var time:int
var curr_player:Player

# UI
@onready var moneyUI:Label = get_node("%camera+static ui/%Money Number")
@onready var foodUI:Label = get_node("%camera+static ui/%Food Number")
@onready var energyUI:Label = get_node("%camera+static ui/%Energy Number")
@onready var BMUI:Label = get_node("%camera+static ui/%BM Number")
@onready var CGUI:Label = get_node("%camera+static ui/%CG Number")
@onready var CompositesUI:Label = get_node("%camera+static ui/%Composites Number")
@onready var staticUI:StaticUI = get_node("%camera+static ui/%UI")
@onready var buildMenu:ScrollContainer = staticUI.get_node("%BuildMenu")

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
		if(curr_player.resources.canCombine(extractorPanel.buildable.constructionCost.negateNoMod())):
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
	curr_player.resources.money = 22000 # 15000 before demo
	curr_player.resources.food = 13000 # 5000 before demo
	curr_player.resources.building_materials = 9000 # 5000 before demo
	curr_player.resources.energy = 7000 # 0 before demo
	curr_player.resources.consumer_goods = 4000 # 0 before demo
	curr_player.resources.composites = 600 # 0 before demo
	
	# Connect all signals from child nodes to this script
	for rn in get_node("%Res Nodes").get_children():
		rn.node_clicked.connect(_on_res_node_clicked)
	for extractorPanel:extractorBuildButton in staticUI.extractorPanels:
		extractorPanel.build_button_clicked.connect(_on_build_button_pressed)
	for city:City in get_node("%Cities").get_children():
		city.taxes_collected.connect(_on_taxes_collected)
		city.production_tick.connect(_on_city_production_tick)
	
	# Hide build menu
	buildMenu.visible = false
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
	var cities = get_node("%Cities").get_children()
	
	# Update time and time-based events
	if(time != Time.get_ticks_msec() / 1000):
		time = Time.get_ticks_msec() / 1000
		#print(time)
		
		# Update buildables
		for extractor in extractors:
			extractor.doProductionTick(TIMEMUL)
		for city:City in cities:
			city.doProductionTick(TIMEMUL)
	
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
	newEx.set_meta("Type", type)
	newEx.position = get_global_mouse_position()
	
	# Add to extractors node
	get_node("%Extractors").add_child(newEx)
	
	# Subtract extractor construction cost from the player's resources
	curr_player.resources.combine(newEx.exStats.constructionCost.negateNoMod())
	pass

func _on_city_placed(city_position:Vector2) -> void:
	# Load resource and instanciate
	var newCityRes:Resource = load("res://gameObjects/city/city.tscn")
	var newCity:City = newCityRes.instantiate()
	
	# Set extractor variables and metadata
	newCity.set_meta("ownerID", curr_player.id)
	newCity.position = get_global_mouse_position() #TODO: change to pioneer's position
	
	# Add to cities node and connect production signal
	get_node("%Cities").add_child(newCity)
	newCity.production_tick.connect(_on_city_production_tick)
	
	# TODO: delete pioneer unit
	pass

func _on_res_node_clicked(extractor:String) -> void:
	placeRecourceExtractor(extractor)

func _on_build_button_pressed(extractor:String) -> void:
	# Cancel building previous extractor
	var buildNode := get_node("ExtractorPlacementUI")
	if(buildNode): buildNode.queue_free()
	
	staticUI.toggleBuildMenu()
	placeRecourceExtractor(extractor)

func _on_city_production_tick(city:City) -> void:
	if (city.get_meta("ownerID") != curr_player.id): pass
	var resourceCheck:int = city.checkResources(curr_player.resources)
	if (resourceCheck == 0): # Normal production
		if (city.stockpile < 18*2): city.stockpile += 1
		city.growPopulation(1)
		curr_player.resources.combine(city.inputs.negateNoMod())
	elif (resourceCheck == 3): # City starving AND no consumer goods - no tax production, shrink population
		city.growPopulation(-0.1)
	elif (resourceCheck == 1): # City starving - no tax production, shrink population, consume CG
		city.growPopulation(-0.1)
		curr_player.resources.consumer_goods -= city.inputs.consumer_goods
	elif (resourceCheck == 2): # No consumer goods - less tax production, less population growth, consume food
		if (city.stockpile >= 18*2): city.stockpile += 0.5
		city.growPopulation(0.5)
		curr_player.resources.food -= city.inputs.food
	return

func _on_taxes_collected(taxes:int) -> void:
	curr_player.resources.money += taxes
	return
