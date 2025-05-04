extends Polygon2D
class_name cityPlacementUI

# UI colors
var innerGreen:Color = Color.hex(0x2f5e2b90)
var innerRed:Color = Color.hex(0xe8493890)
var outerGreen:Color = Color.hex(0x2ee23439)
var outerOrange:Color = Color.hex(0xe38b2d39)

# Nodes
@onready var innerCirc:Polygon2D = get_node("%Inner")
@onready var innerColl:Area2D = get_node("%InnerColl")
@onready var middleCirc:Polygon2D = get_node("%Middle")
@onready var middleColl:Area2D = get_node("%MiddleColl")
@onready var outerCirc:Polygon2D = get_node("%Outer")
@onready var outerColl:Area2D = get_node("%OuterColl")
@onready var master:Master = get_parent()

# Warnings UI
@onready var Camera:Camera2D = get_parent().get_node("%camera+static ui")
@onready var UI_warnings:Panel = get_node("Warnings")
@onready var UI_regionWarn:Label = get_node("%RegionWarning")
@onready var UI_closeWarn:Label = get_node("%RangeWarning")
@onready var UI_farWarn:Label = get_node("%FarWarning")
@onready var UI_resNodeWarn:Label = get_node("%ResNodeWarning")

# Collision checks
var innerValid:bool = true
var middleValid:bool = true
var outerValid:bool = true

# Bools that combine to check placement validity
var isRightRegion:bool = true
var isWithinCityRange:bool = false
var isNotEncroachingCity:bool = true
var isNotEncroachingResNode:bool = true

# Count cities within range and encroaching cities
var rangeCitiesCount:int = 0
var encroachingCitiesCount:int = 0

# Collision priority (Ascending)
var collisionNames:Array[String]
var regionPriority:Array[String] = ["ocean", "barren", "plains", "forest", "mountains", "river"]

# Signal that is emitted when city is placed
signal ready_to_place(city_position:Vector2)

func updateWarnings() -> void:
	var warningsArr:Array[Label]
	
	 #Make everything invisible if placement is valid
	if (innerValid && middleValid && outerValid):
		UI_warnings.visible = false
		return
	
	# Make panel valid
	UI_warnings.visible = true
	
	# Get the list of placement conditions that are not met
	if(!isRightRegion): warningsArr.append(UI_regionWarn)
	else: UI_regionWarn.visible = false
	
	if(!isWithinCityRange): warningsArr.append(UI_farWarn)
	else: UI_farWarn.visible = false
	
	if(!isNotEncroachingCity): warningsArr.append(UI_closeWarn)
	else: UI_closeWarn.visible = false
	
	if(!isNotEncroachingResNode): warningsArr.append(UI_resNodeWarn)
	else: UI_resNodeWarn.visible = false
	
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

func _ready() -> void:
	position = Vector2(-5000, -5000) # Workaround for collision detection bug
	return

func _process(delta: float) -> void:
	# Update position and warnings
	self.position = get_global_mouse_position()
	updateWarnings()
	
	# On left click, signal to place city then delete UI
	if Input.is_action_just_pressed("LMB"):
		if(innerValid && middleValid && outerValid):
			ready_to_place.emit(self.position)
			self.queue_free()
	
	# On escape, delete UI
	if Input.is_action_just_pressed("cancel"):
		self.queue_free()
	return

# First (innermost) radius - checks for correcct region and encroaching res node
func _on_inner_collision_area_entered(area: Area2D) -> void:
	if(area.name == "ResNodeColl"): isNotEncroachingResNode = false
	else: # Region - add to array of colliders
		collisionNames.append(area.name) 
	
		# Check to see if inner collider is in the correct region
		if checkRegion("barren") || checkRegion("plains"): isRightRegion = true
		else: isRightRegion = false
	
	if(isNotEncroachingResNode && isRightRegion):
		innerCirc.color = innerGreen
		innerValid = true
	else:
		innerCirc.color = innerRed
		innerValid = false
	return

func _on_inner_collision_area_exited(area: Area2D) -> void:
	if(area.name == "ResNodeColl"): isNotEncroachingResNode = true
	else: # Region - remove region name from array of colliders
		for i in range(collisionNames.size()):
			if(collisionNames[i] == area.name):
				collisionNames.pop_at(i)
				break
	
		# Check to see if inner collider is in the correct region
		if checkRegion("barren") || checkRegion("plains"): isRightRegion = true
		else: isRightRegion = false
	
	if(isNotEncroachingResNode && isRightRegion):
		innerCirc.color = innerGreen
		innerValid = true
	else:
		innerCirc.color = innerRed
		innerValid = false
	return


# Second radius - if a city is within here, placement is invalid
func _on_middle_collision_area_entered(area: Area2D) -> void:
	if(area.name == "CityInnerColl"):
		encroachingCitiesCount += 1
		isNotEncroachingCity = !encroachingCitiesCount
	
	if isNotEncroachingCity:
		middleCirc.color = outerGreen
		middleValid = true
	else:
		middleCirc.color = outerOrange
		middleValid = false
	return

func _on_middle_collision_area_exited(area: Area2D) -> void:
	if(area.name == "CityInnerColl"):
		encroachingCitiesCount -= 1
		isNotEncroachingCity = !encroachingCitiesCount
	
	if isNotEncroachingCity:
		middleCirc.color = outerGreen
		middleValid = true
	else:
		middleCirc.color = outerOrange
		middleValid = false
	return

# Third radius - if no cities owned by the player are within here, placement is invalid
func _on_outer_collision_area_entered(area: Area2D) -> void:
	if(area.name == "CityInnerColl"):
		print("entering " + str(area.get_parent().get_meta("ownerID")) + " " + str( master.curr_player.id))
		if (area.get_parent().get_meta("ownerID") == master.curr_player.id): # If collided city owner == current player...
			rangeCitiesCount += 1
			isWithinCityRange = rangeCitiesCount
			print(rangeCitiesCount as bool)
	
	if isWithinCityRange:
		outerCirc.color = outerGreen
		outerValid = true
	else:
		outerCirc.color = outerOrange
		outerValid = false
	return

func _on_outer_collision_area_exited(area: Area2D) -> void:
	if(area.name == "CityInnerColl"):
		print("leaving " + str(area.get_parent().get_meta("ownerID")) + " " + str( master.curr_player.id))
		if (area.get_parent().get_meta("ownerID") == master.curr_player.id): # If collided city owner == current player...
			rangeCitiesCount -= 1
			isWithinCityRange = rangeCitiesCount
			print(rangeCitiesCount as bool)
	
	if isWithinCityRange:
		outerCirc.color = outerGreen
		outerValid = true
	else:
		outerCirc.color = outerOrange
		outerValid = false
	return
