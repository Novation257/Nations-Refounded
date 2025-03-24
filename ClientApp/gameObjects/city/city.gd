extends Node2D
class_name City

var scaleMod:float = .005

# Population constants
var initialPopulation:int = 1000
var maxPopulation:int = 1000000
var growthRate:float = .02 
var timeExp:float = .75
var timeMul:float = 4

# Production/consumption constants
var TPP:float = .4   # 400 per 1000 pop
var FPP:float = .1   # 100 per 1000 pop
var CGPP:float = .05 # 50 per 1000 pop (when pop is over 100,000)

# Nodes
var cityLimits:Polygon2D

# Production
var population:int = initialPopulation
var productionTime:int = 1800 # 30 minutes
var productionCountdown:int = productionTime
var stockpile:int = 0
var production:Resources = Resources.new()

# Signal
signal production_tick(city:City)

func growPopulation(modifier:float) -> void:
	population += (growthRate * population)* max(0, 1-(population/maxPopulation)) * modifier

# Add production to the extractor and increase stockpile when necessary
func doProductionTick(time:int) -> void:
	#print("Doing tick on extractor:" + name)
	productionCountdown -= time
	if(productionCountdown <= 0): # Production cycle completed
		stockpile += 1
		productionCountdown = productionTime + productionCountdown
	return

# Check if the player has enough resources to supply the city
func checkResources(cityConsumption:Resources, playerResources:Resources) -> int:
	var temp:Resources = Resources.new()
	temp.combine(cityConsumption)
	temp.negate()
	temp.combine(playerResources)
	if temp.food < 0: return 1
	if temp.consumer_goods < 0: return 2
	else: return 0

func _ready() -> void:
	cityLimits = get_node("%CityLimitsPoly")
	pass

func _process(delta: float) -> void:
	#cityLimits.scale[0] += scaleMod
	#cityLimits.scale[1] = cityLimits.scale[0]
	#if(cityLimits.scale[0] >= 4 || cityLimits.scale[0] <= 2): scaleMod *= -1
	pass


func _on_inherited_collision_mouse_entered() -> void:
	pass # Replace with function body.
