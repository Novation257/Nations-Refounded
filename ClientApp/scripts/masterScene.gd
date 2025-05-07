extends Node2D
class_name Master

const AUTOCOLLECT:bool = false
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
var placingObject:bool = false

func placeRecourceExtractor(type:String) -> void:
	# Load extractor UI and instanciate
	var newUIRes:Resource = load("res://gameObjects/extractor/ExtractorPlacementUI.tscn")
	var placementUI:ExtractorPlacementUI = newUIRes.instantiate()
	placementUI.position = get_global_mouse_position()
	get_node(".").add_child(placementUI)
	placementUI.setType(type)
	
	# Connect signal
	placementUI.ready_to_place.connect(_on_extractor_placed)
	pass

func placeCity(cityName:String) -> void:
	# Load city UI and instanciate
	var newUIRes:Resource = load("res://gameObjects/city/cityPlacementUI.tscn")
	var placementUI:cityPlacementUI = newUIRes.instantiate()
	placementUI.position = get_global_mouse_position()
	get_node(".").add_child(placementUI)
	placementUI.cityName = cityName
	
	# Connect signal
	placementUI.ready_to_place.connect(_on_city_placed)
	pass

# Check if any extractor was clicked and attempt to collect resources
func check_extractor_collection(extractors:Array[Node]) -> void:
	for extractor in extractors:
		# If the clicked extractor is owned by the current player
		if (extractor.clicked == true || (AUTOCOLLECT && extractor.stockpile > 0)) && extractor.get_meta("ownerID") == curr_player.id:
			var ex_name = extractor.get_meta("Type")
			# If there are no resources in the extractor...
			if extractor.stockpile == 0: staticUI.notify(ex_name + " has no resources to collect")
			# If the player has the resources to collect...
			elif curr_player.resources.canCombine(extractor.get_stored()):
				if !AUTOCOLLECT: staticUI.notify("Collected resources from " + ex_name)
				#extractor.get_stored().print()
				curr_player.resources.combine(extractor.collect())
			else:
				staticUI.notify("Not enough resources to collect from " + ex_name)
				#extractor.get_stored().print()

func update_extractor_build_buttons() -> void:
	for extractorPanel:extractorBuildButton in staticUI.extractorPanels:
		if(curr_player.resources.canCombine(extractorPanel.buildable.constructionCost.negateNoMod())):
			extractorPanel.buildButton.text = "Build"
			extractorPanel.buildButton.disabled = false
		else:
			extractorPanel.buildButton.text = "Insufficient Materials"
			extractorPanel.buildButton.disabled = true

func update_city_build_button() -> void:
	var buildMenu:cityBuildButton = staticUI.cityBuildMenu
	if(curr_player.resources.canCombine(buildMenu.constructionCost.negateNoMod())):
		if buildMenu.nameInput.text != "":
			for city:City in get_node("%Cities").get_children():
				if city.name == buildMenu.nameInput.text:
					# Good resources, text in field - city name taken
					buildMenu.buildButton.text = "Name Taken"
					buildMenu.buildButton.disabled = true
					return
			# Good resources, text in field, good name
			buildMenu.buildButton.text = "Build"
			buildMenu.buildButton.disabled = false
		else:
			# Good resources - no text in field
			buildMenu.buildButton.text = "Input Name"
			buildMenu.buildButton.disabled = true
	else:
		# Insufficient resources
		buildMenu.buildButton.text = "Insufficient Materials"
		buildMenu.buildButton.disabled = true

func update_ui() -> void:
	moneyUI.text = str(curr_player.resources.money)
	foodUI.text = str(curr_player.resources.food)
	energyUI.text = str(curr_player.resources.energy)
	BMUI.text = str(curr_player.resources.building_materials)
	CGUI.text = str(curr_player.resources.consumer_goods)
	CompositesUI.text = str(curr_player.resources.composites)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize player
	curr_player = Player.new()
	curr_player.id = 1
	curr_player.resources.money = 17500 # 15000 before demo
	curr_player.resources.food = 7500 # 5000 before demo
	curr_player.resources.building_materials = 75000 # 5000 before demo
	curr_player.resources.energy = 7000 # 0 before demo
	curr_player.resources.consumer_goods = 3000 # 0 before demo
	curr_player.resources.composites = 600 # 0 before demo
	
	# Connect all signals from child nodes to this script
	for rn in get_node("%Res Nodes").get_children():
		rn.node_clicked.connect(_on_res_node_clicked)
	for extractorPanel:extractorBuildButton in staticUI.extractorPanels:
		extractorPanel.build_button_clicked.connect(_on_extractor_build_button_pressed)
	for city:City in get_node("%Cities").get_children():
		city.taxes_collected.connect(_on_taxes_collected)
		city.production_tick.connect(_on_city_production_tick)
	staticUI.cityBuildMenu.build_button_clicked.connect(_on_city_build_button_pressed)
	# Hide build menu
	buildMenu.visible = false
	return

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
	update_extractor_build_buttons()
	update_city_build_button()
	
	# Run input routines if button is pressed
	if Input.is_action_just_pressed("debug1"):
		staticUI.notify("This is a message")
	if Input.is_action_just_pressed("debug2"):
		placeCity("Knoxville")
	if Input.is_action_just_pressed("debug3"):
		pass
	if Input.is_action_just_pressed("BuildMenuToggle"):
		staticUI.toggleBuildMenu()
	
	# Update UI
	update_ui()

func _on_extractor_placed(extractor_position:Vector2, type:String) -> void:
	# Load resource and instanciate
	var newExRes:Resource = load("res://gameObjects/extractor/GenericExtractor.tscn")
	var newEx:Extractor = newExRes.instantiate()
	
	# Check again if the player has enough resources to build extractor
	if(!curr_player.resources.canCombine((newEx.exStats.constructionCost.negateNoMod()))):
		staticUI.notify("Not enough resources to build " + type)
		newEx.queue_free()
		return
	
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

func _on_city_placed(city_position:Vector2, cityName:String) -> void:
	# Load resource and instanciate
	var newCityRes:Resource = load("res://gameObjects/city/city.tscn")
	var newCity:City = newCityRes.instantiate()
	
	# Check again if the player has enough resources to build city
	if(!curr_player.resources.canCombine((newCity.constructionCost.negateNoMod()))):
		staticUI.notify("Not enough resources to build city")
		newCity.queue_free()
		return
	
	# Set city variables and metadata
	newCity.set_meta("ownerID", curr_player.id)
	newCity.position = get_global_mouse_position() #TODO: change to pioneer's position
	newCity.name = cityName
	newCity.population = newCity.initialPopulation
	newCity.set_meta("population", newCity.population)
	
	# Add to cities node and connect production signal
	get_node("%Cities").add_child(newCity)
	newCity.production_tick.connect(_on_city_production_tick)
	
	# Subtract city construction cost from the player's resources
	curr_player.resources.combine(newCity.constructionCost.negateNoMod())
	
	# TODO: delete pioneer unit
	pass

func _on_res_node_clicked(extractor:String) -> void:
	placeRecourceExtractor(extractor)

func _on_extractor_build_button_pressed(extractor:String) -> void:
	# Cancel building previous extractor
	var buildNode := get_node("ExtractorPlacementUI")
	if(buildNode): buildNode.queue_free()
	
	staticUI.toggleBuildMenu()
	placeRecourceExtractor(extractor)

func _on_city_build_button_pressed() -> void:
	# Cancel building previous extractor
	var buildNode := get_node("CityPlacementUI")
	if(buildNode): buildNode.queue_free()
	
	staticUI.toggleCityMenu()
	placeCity(staticUI.cityBuildMenu.nameInput.text)
	staticUI.cityBuildMenu.nameInput.clear()

func _on_city_production_tick(city:City) -> void:
	if (city.get_meta("ownerID") != curr_player.id): pass
	var resourceCheck:int = city.checkResources(curr_player.resources)
	if (resourceCheck == 0): # Normal production
		if (city.stockpile < city.maxStockpile): city.stockpile += 1
		city.growPopulation(1)
		curr_player.resources.combine(city.inputs.negateNoMod())
	elif (resourceCheck == 3): # City starving AND no consumer goods - no tax production, shrink population
		city.growPopulation(-2)
		curr_player.resources.food = 0
		curr_player.resources.consumer_goods = 0
	elif (resourceCheck == 1): # City starving - no tax production, shrink population, consume CG
		city.growPopulation(-2)
		curr_player.resources.food = 0
		curr_player.resources.consumer_goods -= city.inputs.consumer_goods
	elif (resourceCheck == 2): # No consumer goods - less tax production, less population growth, consume food
		if (city.stockpile >= city.maxStockpile): city.stockpile += 0.5
		city.growPopulation(0.25)
		curr_player.resources.food -= city.inputs.food
		curr_player.resources.consumer_goods = 0
	return

func _on_taxes_collected(taxes:int) -> void:
	curr_player.resources.money += taxes
	staticUI.notify("Collected " + str(taxes) + " money from city")
	return
