class_name ExtractorType

var typeName:String

const _NUMTYPES:int = 20 # Incrament this if adding a new extractor type
const _BASEMOD:int = 4
const _RNOUTPUTMOD:int = 6

# Construction
var constructionCost:Resources = Resources.new()
var constructionTime:int = 3600
var constructionRegion:String
var constructionResNode:String = ""

# Production
var inputs:Resources = Resources.new()
var outputs:Resources = Resources.new()


# Sets the input and output values for different extractors
func setType(type:String) -> ExtractorType:
	typeName = type
	match type:
		# Money factories
		"Silver Mine", "1":
			typeName = "Silver Mine"
			inputs.energy = 8 * _BASEMOD
			outputs.money = 20 * _RNOUTPUTMOD
			constructionCost.money = 750 * _BASEMOD
			constructionCost.building_materials = 300 * _BASEMOD
			constructionCost.composites = 100 * _BASEMOD
			constructionRegion = "mountains"
			constructionResNode = "Silver"
		"Gold Mine", "2":
			typeName = "Gold Mine"
			inputs.energy = 8 * _BASEMOD
			outputs.money = 35 * _RNOUTPUTMOD
			constructionCost.money = 750 * _BASEMOD
			constructionCost.building_materials = 300 * _BASEMOD
			constructionCost.composites = 100 * _BASEMOD
			constructionRegion = "mountains"
			constructionResNode = "Gold"
		
		# Food factories
		"Rice Farm", "3":
			typeName = "Rice Farm"
			inputs.money = 7  * _BASEMOD
			outputs.food = 3 * _BASEMOD
			constructionCost.money = 750 * _BASEMOD
			constructionCost.building_materials = 300 * _BASEMOD
			constructionRegion = "plains"
		"Dairy Farm", "4":
			typeName = "Dairy Farm"
			inputs.money = 4 * _BASEMOD
			inputs.energy = 7 * _BASEMOD
			outputs.food = 8 * _RNOUTPUTMOD
			constructionCost.money = 600 * _BASEMOD
			constructionCost.building_materials = 250 * _BASEMOD
			constructionRegion = "plains"
			constructionResNode = "Cattle"
		"Fishery", "5":
			typeName = "Fishery"
			inputs.money = 3 * _BASEMOD
			inputs.energy = 6 * _BASEMOD
			outputs.food = 7 * _RNOUTPUTMOD
			constructionCost.money = 600 * _BASEMOD
			constructionCost.building_materials = 250 * _BASEMOD
			constructionRegion = "ocean"
			constructionResNode = "Fish"
		"Banana Plantation", "6":
			typeName = "Banana Plantation"
			inputs.money = 3 * _BASEMOD
			inputs.energy = 6 * _BASEMOD
			outputs.food = 7 * _RNOUTPUTMOD
			constructionCost.money = 750 * _BASEMOD
			constructionCost.building_materials = 300 * _BASEMOD
			constructionRegion = "forest"
			constructionResNode = "Bananas"
		
		# Power factories
		"Wind Turbine", "7":
			typeName = "Wind Turbine"
			inputs.money = 12 * _BASEMOD
			outputs.energy = 12 * _BASEMOD
			constructionCost.money = 350 * _BASEMOD
			constructionCost.building_materials = 150 * _BASEMOD
			constructionRegion = "barren"
		"Hydroelectric Dam", "8":
			typeName = "Hydroelectric Dam"
			inputs.money = 18 * _BASEMOD
			outputs.energy = 32 * _BASEMOD
			constructionCost.money = 500 * _BASEMOD
			constructionCost.building_materials = 300 * _BASEMOD
			constructionCost.composites = 75 * _BASEMOD
			constructionRegion = "river"
		"Coal Power Plant", "9":
			typeName = "Coal Power Plant"
			inputs.money = 22 * _BASEMOD
			outputs.energy = 48 * _RNOUTPUTMOD
			constructionCost.money = 600 * _BASEMOD
			constructionCost.building_materials = 400 * _BASEMOD
			constructionCost.composites = 75 * _BASEMOD
			constructionRegion = "mountains"
			constructionResNode = "Coal"
		
		# Building materials factories
		"Sawmill", "10":
			typeName = "Sawmill"
			inputs.money = 4 * _BASEMOD
			inputs.energy = 7 * _BASEMOD
			outputs.building_materials = 4 * _BASEMOD
			constructionCost.money = 950 * _BASEMOD
			constructionRegion = "forest"
		"Quarry", "11":
			typeName = "Quarry"
			inputs.money = 4 * _BASEMOD
			inputs.energy = 7 * _BASEMOD
			outputs.building_materials = 4 * _BASEMOD
			constructionCost.money = 950 * _BASEMOD
			constructionRegion = "mountains"
		"Concrete Factory", "12":
			typeName = "Concrete Factory"
			inputs.money = 5 * _BASEMOD
			inputs.energy = 10 * _BASEMOD
			outputs.building_materials = 9 * _BASEMOD
			constructionCost.money = 675 * _BASEMOD
			constructionCost.building_materials = 125 * _BASEMOD
			constructionCost.composites = 100 * _BASEMOD
			constructionRegion = "barren"
		"Stonemason", "13":
			typeName = "Stonemason"
			inputs.money = 5 * _BASEMOD
			inputs.energy = 10 * _BASEMOD
			outputs.building_materials = 5 * _RNOUTPUTMOD
			outputs.consumer_goods = 3 * _RNOUTPUTMOD
			constructionCost.money = 675 * _BASEMOD
			constructionCost.building_materials = 475 * _BASEMOD
			constructionCost.composites = 250 * _BASEMOD
			constructionRegion = "mountains"
			constructionResNode = "Marble"
		
		# Consumer goods factories
		"Chocolate Factory", "14":
			typeName = "Chocolate Factory"
			inputs.money = 3 * _BASEMOD
			inputs.energy = 5 * _BASEMOD
			outputs.consumer_goods = 2 * _RNOUTPUTMOD
			constructionRegion = "forest"
			constructionResNode = "Cocoa"
		"Clothing Factory", "15":
			typeName = "Clothing Factory"
			inputs.money = 4 * _BASEMOD
			inputs.energy = 7 * _BASEMOD
			outputs.consumer_goods = 2 * _RNOUTPUTMOD
			constructionCost.money = 575 * _BASEMOD
			constructionCost.building_materials = 350 * _BASEMOD
			constructionCost.composites = 75 * _BASEMOD
			constructionRegion = "plains"
			constructionResNode = "Sheep"
		"Tobacco Plantation", "16":
			typeName = "Tobacco Plantation"
			inputs.money = 4 * _BASEMOD
			inputs.energy = 7 * _BASEMOD
			outputs.consumer_goods = 4 * _RNOUTPUTMOD
			constructionCost.money = 450 * _BASEMOD
			constructionCost.building_materials = 350 * _BASEMOD
			constructionCost.composites = 175 * _BASEMOD
			constructionRegion = "forest"
			constructionResNode = "Tobacco"
		"Phone Factory", "17":
			typeName = "Phone Factory"
			inputs.money = 8 * _BASEMOD
			inputs.energy = 12 * _BASEMOD
			inputs.composites = 3 * _BASEMOD
			outputs.consumer_goods = 10 * _BASEMOD
			constructionCost.money = 700 * _BASEMOD
			constructionCost.building_materials = 525 * _BASEMOD
			constructionCost.composites = 275 * _BASEMOD
			constructionRegion = "barren"
		
		# Composites factories
		"Aluminum Refinery", "18":
			typeName = "Aluminum Refinery"
			inputs.money = 6 * _BASEMOD
			inputs.energy = 11 * _BASEMOD
			outputs.composites = 2 * _RNOUTPUTMOD
			constructionCost.money = 1000 * _BASEMOD
			constructionCost.building_materials = 525 * _BASEMOD
			constructionRegion = "mountains"
			constructionResNode = "Bauxite"
		"Advanced Materials Facility", "19":
			typeName = "Advanced Materials Facility"
			inputs.money = 5 * _BASEMOD
			inputs.energy = 10 * _BASEMOD
			inputs.building_materials = 5 * _BASEMOD
			outputs.composites = 2 * _BASEMOD
			constructionCost.money = 1200 * _BASEMOD
			constructionCost.building_materials = 600 * _BASEMOD
			constructionRegion = "mountains"
		"Platinum Mine", "20":
			typeName = "Platinum Mine"
			inputs.money = 8 * _BASEMOD
			inputs.energy = 15 * _BASEMOD
			outputs.composites = 4 * _RNOUTPUTMOD
			constructionCost.money = 1400 * _BASEMOD
			constructionCost.building_materials = 750 * _BASEMOD
			constructionRegion = "mountains"
			constructionResNode = "Platinum"
		_:
			print("Unable to match extractorType " + type)
	return

func all() -> Array[ExtractorType]:
	var returnArray: Array[ExtractorType]
	
	for i in range(1, _NUMTYPES+1): 
		var newEx = ExtractorType.new()
		newEx.setType(str(i))
		returnArray.append(newEx)
	return returnArray
