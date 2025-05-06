extends Polygon2D
class_name ExtractorPlacementUI

# Extractor type to be placed
var type:String
var typeData:ExtractorType = ExtractorType.new()

# UI colors
var innerGreen:Color = Color.hex(0x2f5e2bff)
var innerRed:Color = Color.hex(0xe84938ff)
var outerGreen:Color = Color.hex(0x2ee23469)
var outerOrange:Color = Color.hex(0xe38b2d69)

# Nodes
@onready var innerCube:Polygon2D = get_node("%Inner cube")
@onready var outerCube:Polygon2D = self
@onready var innerColl:Area2D = get_node("%InnerCollision")
@onready var outerColl:Area2D = get_node("%OuterCollision")

# Warnings UI
@onready var Camera:Camera2D = get_parent().get_node("%camera+static ui")
@onready var UI_warnings:Panel = get_node("Warnings")
@onready var UI_regionWarn:Label = get_node("%RegionWarning")
@onready var UI_extractorWarn:Label = get_node("%ExtractorWarning")
@onready var UI_cityWarn:Label = get_node("%CityWarning")
@onready var UI_resTypeWarn:Label = get_node("%ResTypeWarning")
@onready var UI_resNodeWarn:Label = get_node("%ResNodeWarning")
@onready var UI_cityLimitsWarn:Label = get_node("%CityLimitsWarning")

# Collision checks
var innerValid:bool = true
var outerValid:bool = true

# Bools that combine to check outerValid
var isNotEncroachingExtractor:bool = true
var isRightResNode:bool = true

# Bools that combine to check innerValid
var isRightRegion:bool = true
var isWithinCityLimits:bool = false
var isNotEncroachingResNode:bool = true
var isNotEncroachingCity:bool = true

# Count encroaching extractors and cities
var encroachingExtractorsCount:int = 0
var cityLimitsCount:int = 0

# Collision priority (Ascending)
var collisionNames:Array[String]
var regionPriority:Array[String] = ["ocean", "barren", "plains", "forest", "mountains", "river"]

# Signal that is emitted when extractor is placed
signal ready_to_place(extractor_position:Vector2, type:String)

func updateWarnings() -> void:
	var warningsArr:Array[Label]
	
	# Make everything invisible if placement is valid
	if (innerValid && outerValid):
		UI_warnings.visible = false
		return
	
	# Make panel valid
	UI_warnings.visible = true
	
	# Get the list of placement conditions that are not met
	if(!isNotEncroachingExtractor): warningsArr.append(UI_extractorWarn)
	else: UI_extractorWarn.visible = false
	
	if(!isRightResNode):
		warningsArr.append(UI_resTypeWarn)
		UI_resTypeWarn.text = "Must be built near " + typeData.constructionResNode
	else: UI_resTypeWarn.visible = false
	
	if(!isRightRegion):
		warningsArr.append(UI_regionWarn)
		UI_regionWarn.text = "Must be built on " + typeData.constructionRegion
	else: UI_regionWarn.visible = false
	
	if(!isWithinCityLimits): warningsArr.append(UI_cityLimitsWarn)
	else: UI_cityLimitsWarn.visible = false
	
	if(!isNotEncroachingResNode): warningsArr.append(UI_resNodeWarn)
	else: UI_resNodeWarn.visible = false
	
	if(!isNotEncroachingCity): warningsArr.append(UI_cityWarn)
	else: UI_cityWarn.visible = false
	
	# Make labels visible and position them in a list
	var i := 5
	var longestWarn := 0
	for warning:Label in warningsArr:
		warning.visible = true
		warning.position = Vector2(5, i)
		longestWarn = max(warning.size.x, longestWarn)
		i += 25
	
	# Update panel size and scale
	UI_warnings.size = Vector2(longestWarn + 10, i)
	UI_warnings.scale[0] = 1/Camera.zoom[0]
	UI_warnings.scale[1] = UI_warnings.scale[0]
	return


func checkRegion(regionName:String) -> bool:
	var regionInArray = false
	var regionIndex:int = -1
	
	# Get region priority
	for i in range(regionPriority.size()):
		if regionPriority[i] == regionName:
			regionIndex = i
	
	# Check if region was found (fail check if not)
	if regionIndex == -1:
		print("Could not assess region priority of: " + regionName)
		return false
	
	# Make sure the desired region is in the array of colliders (fail check if not)
	for i in range(collisionNames.size()):
		if collisionNames[i] == regionName: regionInArray = true
	if !regionInArray:
		return false
	
	# Make sure none of the higher-priority regions are in the array of colliders (fail check if found)
	for i in range(regionIndex + 1, regionPriority.size()):
		for j in range(collisionNames.size()):
			if regionPriority[i] == collisionNames[j]:
				return false
	
	# If no checks find a fault, return true
	return true

func setType(type:String):
	self.type = type
	typeData.setType(type)
	return

func _ready() -> void:
	position = Vector2(-10000, -10000) # Workaround for collision detection bug
	return

func _process(delta: float) -> void:
	# Update position and warnings
	self.position = get_global_mouse_position()
	updateWarnings()
	
	# On left click, signal to place extractor then delete UI
	if Input.is_action_just_pressed("LMB"):
		if(innerValid && outerValid):
			ready_to_place.emit(self.position, self.type)
			self.queue_free()
	
	# On escape, delete UI
	if Input.is_action_just_pressed("cancel"):
		self.queue_free()
	return


# When the correct regions are touched, placement is valid
func _on_inner_collision_area_entered(area: Area2D) -> void:
	if(area.name == "ResNodeColl"): isNotEncroachingResNode = false
	if(area.name == "CityInnerColl"): isNotEncroachingCity = false
	if(area.name == "CityLimitsColl"):
		cityLimitsCount += 1
		isWithinCityLimits = cityLimitsCount
	else: # Region - add to array of colliders
		collisionNames.append(area.name) 
	
		# Check to see if inner collider is in the correct region
		if checkRegion(typeData.constructionRegion): isRightRegion = true
		else: isRightRegion = false
	
	if(isNotEncroachingCity && isNotEncroachingResNode && isRightRegion && isWithinCityLimits):
		innerCube.color = innerGreen
		innerValid = true
	else:
		innerCube.color = innerRed
		innerValid = false
	return

func _on_inner_collision_area_exited(area: Area2D) -> void:
	print("Exited " + area.name + str(cityLimitsCount))
	if(area.name == "ResNodeColl"): isNotEncroachingResNode = true
	if(area.name == "CityInnerColl"): isNotEncroachingCity = true
	if(area.name == "CityLimitsColl"):
		cityLimitsCount -= 1
		isWithinCityLimits = cityLimitsCount
	else: # Region - remove region name from array of colliders
		for i in range(collisionNames.size()):
			if(collisionNames[i] == area.name):
				collisionNames.pop_at(i)
				break
	
		# Check to see if inner collider is in the correct region
		if checkRegion(typeData.constructionRegion): isRightRegion = true
		else: isRightRegion = false
	
	if(isNotEncroachingCity && isNotEncroachingResNode && isRightRegion && isWithinCityLimits):
		innerCube.color = innerGreen
		innerValid = true
	else:
		innerCube.color = innerRed
		innerValid = false
	return


# Outer collision - when not touching another extractor and when touching the correct resource node (when applicable), placement is valid
func _on_outer_collision_area_entered(area: Area2D) -> void:
	if !typeData.constructionResNode.is_empty():
		if area.get_parent().get_meta("resource") == typeData.constructionResNode:
			isRightResNode = true

	if(area.name == "ExtractorColl"):
		encroachingExtractorsCount += 1
		isNotEncroachingExtractor = !encroachingExtractorsCount
	
	if isNotEncroachingExtractor && isRightResNode:
		outerCube.color = outerGreen
		outerValid = true
	else:
		outerCube.color = outerOrange
		outerValid = false
	return

func _on_outer_collision_area_exited(area: Area2D) -> void:
	if !typeData.constructionResNode.is_empty():
		if area.get_parent().get_meta("resource") == typeData.constructionResNode:
			isRightResNode = false
	
	if(area.name == "ExtractorColl"):
		encroachingExtractorsCount -= 1
		isNotEncroachingExtractor= !encroachingExtractorsCount
	
	if isNotEncroachingExtractor && isRightResNode:
		outerCube.color = outerGreen
		outerValid = true
	else:
		outerCube.color = outerOrange
		outerValid = false
	return
