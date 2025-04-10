extends Node2D
class_name City

# Identifiers
var id:int

# UI
var Camera:Camera2D
var UI:Panel
var UI_name:Label
var UI_ownerID:Label
var UI_population:Label
var UI_stockpile:Label
var UI_TTP:Label

# Signaling
signal production_tick(city:City)
signal taxes_collected(taxes:int)

# Population constants
var initialPopulation:int = 1000
var maxPopulation:int = 500000
var growthRate:float = .02 
var timeExp:float = .75
var timeMul:float = 4

# Nodes
var cityLimits:Polygon2D

# Production
var population:int = initialPopulation
var productionTime:int = 1800 # 30 minutes
var productionCountdown:int = productionTime
var stockpile:float = 0
var inputs:Resources = Resources.new()

func calculateFoodUsage(population:int) -> int:
	return floor((population * .001) - .00006*pow(population, 1.2) + 5)

func calculateCGUsage(population:int) -> int:
	return floor(calculateFoodUsage(population) * .10)

func calculateTaxProduction(population:int) -> int:
	return floor(calculateFoodUsage(population) * 3.5)

func growPopulation(modifier:float) -> void:
	population += (growthRate * population)* max(0, 1-(population/maxPopulation)) * modifier
	set_meta("population", population)

# Add production to the extractor and increase stockpile when necessary
func doProductionTick(time:int) -> void:
	#print("Doing tick on extractor:" + name)
	productionCountdown -= time
	if(productionCountdown <= 0): # Production cycle completed
		production_tick.emit(self)
		productionCountdown = productionTime + productionCountdown
		
		# Update City limits - log scale giving values between ~2 and ~4.5
		cityLimits.scale[0] = max(2, (0.69 * log(population) / log(10) - 0.19) + 1)
		cityLimits.scale[1] = cityLimits.scale[0]
		
		# Update inputs
		inputs.food = calculateFoodUsage(population)
		if (population > 100000): inputs.consumer_goods = calculateCGUsage(population)
		else: inputs.consumer_goods = 0
	
	# Update UI
	UI_population.text = "Population: " + str(get_meta("population"))
	UI_stockpile.text = "Taxes: " + str(calculateTaxProduction(population) * stockpile)
	UI_TTP.text = "TTP: " + str(productionCountdown)
	return

# Check if the player has enough resources to supply the city
func checkResources(playerResources:Resources) -> int:
	var temp:Resources = Resources.new()
	temp.combine(self.inputs.negateNoMod())
	temp.combine(playerResources)
	if temp.food < 0 && temp.consumer_goods < 0: return 3
	if temp.food < 0: return 1
	if temp.consumer_goods < 0: return 2
	else: return 0

func _ready() -> void:
	# Get UI nodes
	Camera = get_parent().get_parent().get_node("%camera+static ui")
	UI = get_node("%UI")
	UI_name = get_node("%name")
	UI_ownerID = get_node("%ownerID")
	UI_population = get_node("%population")
	UI_stockpile = get_node("%stockpile")
	UI_TTP = get_node("%TTP")
	
	cityLimits = get_node("%CityLimitsPoly")
	
	
	# Hide UI and update values
	UI.visible = false
	UI_name.text = name
	UI_ownerID.text = "OwnerID: " + str(get_meta("ownerID"))
	
	# Get population
	population = get_meta("population")
	
	# Update inputs
	inputs.food = calculateFoodUsage(population)
	if (population > 100000): inputs.consumer_goods = calculateCGUsage(population)
	else: inputs.consumer_goods = 0
	pass

func _process(delta: float) -> void:
	# Make UI follow cursor if the UI isn't hidden
	if UI.visible == true:
		# Update scale
		UI.scale[0] = 1/Camera.zoom[0]
		UI.scale[1] = UI.scale[0]
		
		# Update position
		var m_pos:Vector2 = get_local_mouse_position()
		UI.position[0] = m_pos[0] + (12 * UI.scale[0])
		UI.position[1] = m_pos[1] - (0  * UI.scale[0])
	
	pass

func _on_city_inner_coll_mouse_entered() -> void:
	UI.visible = true
	return

func _on_city_inner_coll_mouse_exited() -> void:
	UI.visible = false
	return

# On left click - collect taxes
func _on_city_inner_coll_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(Input.is_action_just_pressed("LMB")):
		print("City clicked")
		# Send taxes to masterScene and empty stockpile
		taxes_collected.emit(calculateTaxProduction(population) * stockpile)
		stockpile = 0
		
		# Update UI
		UI_stockpile.text = "Taxes: 0"
	return
