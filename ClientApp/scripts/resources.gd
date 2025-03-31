class_name Resources

# Resources
var money:int = 0
var food:int = 0
var energy:int = 0
var building_materials:int = 0
var consumer_goods:int = 0
var composites:int = 0

func applyToAll(passedFunc:Callable) -> Resources:
	money = passedFunc.call(money)
	food = passedFunc.call(food)
	energy = passedFunc.call(energy)
	building_materials = passedFunc.call(building_materials)
	consumer_goods = passedFunc.call(consumer_goods)
	composites = passedFunc.call(composites)
	return self

func combine(other:Resources) -> Resources:
	money += other.money
	food += other.food
	energy += other.energy
	building_materials += other.building_materials
	consumer_goods += other.consumer_goods
	composites += other.composites
	return self

# Returns true all resources will be positive after combining
func canCombine(other:Resources) -> bool:
	var otherArray:Array = other.asArray()
	var selfArray:Array = self.asArray()
	for i in range(selfArray.size()):
		if (selfArray[i] + otherArray[i]) < 0: return false
	return true

func negate() -> Resources:
	self.applyToAll(func negate(x:int): return -x)
	return self

# Same as negate, but doesn't change original data
func negateNoMod() -> Resources:
	var tempRes = Resources.new()
	tempRes.combine(self)
	tempRes.applyToAll(func negate(x:int): return -x)
	return tempRes

func asArray() -> Array:
	var resArray:Array[int]
	resArray.append(money)
	resArray.append(food)
	resArray.append(energy)
	resArray.append(building_materials)
	resArray.append(consumer_goods)
	resArray.append(composites)
	return resArray

func print() -> void:
	var selfArray = self.asArray()
	for i in range(selfArray.size()):
		print(str(i) + ": " + str(selfArray[i]))
