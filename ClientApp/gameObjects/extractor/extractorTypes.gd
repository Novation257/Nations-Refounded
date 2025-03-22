class_name ExtractorType

# Construction
var constructionCost:Resources = Resources.new()
var constructionTime:int = 3600
var constructionRegion:String
var constructionResNode:String = ""

# Production
var inputs:Resources = Resources.new()
var outputs:Resources = Resources.new()

# Sets the input and output values for different extractors
func setType(type:String) -> void:
	match type:
		# Money factories
		"Silver Mine":
			inputs.energy = 8
			outputs.money = 20
			constructionCost.money = 750
			constructionCost.building_materials = 300
			constructionCost.composites = 100
			constructionRegion = "mountains"
			constructionResNode = "Silver"
		"Gold Mine":
			inputs.energy = 8
			outputs.money = 35
			constructionCost.money = 750
			constructionCost.building_materials = 300
			constructionCost.composites = 100
			constructionRegion = "mountains"
			constructionResNode = "Gold"
		
		# Food factories
		"Rice Farm":
			inputs.money = 7
			outputs.food = 3
			constructionCost.money = 750
			constructionCost.building_materials = 300
			constructionRegion = "plains"
		"Dairy Farm":
			inputs.money = 4
			inputs.energy = 7
			outputs.food = 8
			constructionCost.money = 600
			constructionCost.building_materials = 250
			constructionRegion = "plains"
			constructionResNode = "Cattle"
		"Fishery":
			inputs.money = 3
			inputs.energy = 6
			outputs.food = 7
			constructionCost.money = 600
			constructionCost.building_materials = 250
			constructionRegion = "ocean"
			constructionResNode = "Fish"
		"Banana Plantation":
			inputs.money = 3
			inputs.energy = 6
			outputs.food = 7
			constructionCost.money = 750
			constructionCost.building_materials = 300
			constructionRegion = "forest"
			constructionResNode = "Bananas"
		
		# Power factories
		"Wind Turbine":
			inputs.money = 6
			outputs.energy = 6
			constructionCost.money = 350
			constructionCost.building_materials = 150
			constructionRegion = "barren"
		"Hydroelectric Dam":
			inputs.money = 9
			outputs.energy = 16
			constructionCost.money = 500
			constructionCost.building_materials = 300
			constructionCost.composites = 75
			constructionRegion = "river"
		"Coal Power Plant":
			inputs.money = 11
			outputs.energy = 24
			constructionCost.money = 600
			constructionCost.building_materials = 400
			constructionCost.composites = 75
			constructionRegion = "mountains"
			constructionResNode = "Coal"
		
		# Building materials factories
		"Sawmill":
			inputs.money = 4
			inputs.energy = 7
			outputs.building_materials = 4
			constructionCost.money = 950
			constructionRegion = "forest"
		"Quarry":
			inputs.money = 4
			inputs.energy = 7
			outputs.building_materials = 4
			constructionCost.money = 950
			constructionRegion = "mountains"
		"Concrete Factory":
			inputs.money = 5
			inputs.energy = 10
			outputs.building_materials = 9
			constructionCost.money = 675
			constructionCost.building_materials = 500
			constructionCost.composites = 250
			constructionRegion = "barren"
		"Stonemason":
			inputs.money = 5
			inputs.energy = 10
			outputs.building_materials = 5
			outputs.consumer_goods = 3
			constructionCost.money = 675
			constructionCost.building_materials = 475
			constructionCost.composites = 250
			constructionRegion = "mountains"
			constructionResNode = "Marble"
		
		# Consumer goods factories
		"Chocolate Factory":
			inputs.energy = 3
			inputs.power = 5
			outputs.consumer_goods = 2
			constructionRegion = "forest"
			constructionResNode = "Cocoa"
		"Clothing Factory":
			inputs.money = 4
			inputs.energy = 7
			outputs.consumer_goods = 2
			constructionCost.money = 575
			constructionCost.building_materials = 350
			constructionCost.composites = 75
			constructionRegion = "plains"
			constructionResNode = "Sheep"
		"Tobacco Plantation":
			inputs.money = 4
			inputs.energy = 7
			outputs.consumer_goods = 4
			constructionCost.money = 450
			constructionCost.building_materials = 350
			constructionCost.composites = 175
			constructionRegion = "forest"
			constructionResNode = "Tobacco"
		"Phone Factory":
			inputs.money = 8
			inputs.energy = 12
			inputs.composites = 3
			outputs.consumer_goods = 10
			constructionCost.money = 700
			constructionCost.building_materials = 525
			constructionCost.composites = 275
			constructionRegion = "barren"
		
		# Composites factories
		"Aluminum Refinery":
			inputs.money = 6
			inputs.energy = 11
			outputs.composites = 2
			constructionCost.money = 1000
			constructionCost.building_materials = 525
			constructionRegion = "mountains"
			constructionResNode = "Bauxite"
		"Advanced Materials Facility":
			inputs.money = 5
			inputs.energy = 10
			inputs.building_materials = 5
			outputs.composites = 2
			constructionCost.money = 1200
			constructionCost.building_materials = 600
			constructionRegion = "mountains"
		"Platinum Mine":
			inputs.money = 8
			inputs.energy = 15
			outputs.composites = 4
			constructionCost.money = 1400
			constructionCost.building_materials = 750
			constructionRegion = "mountains"
			constructionResNode = "Platinum"
	return
