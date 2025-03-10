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

# Same as combine, but does nothing and returns null if one of the values would be made negative
func combineNoNeg(other:Resources) -> Resources:
	self.combine(other)
	for res in self.asArray():
		if res < 0:
			# Undo combine by negating other Resource struct and adding it to self
			self.combine(other.applyToAll(func(x:int): return -x))
			return null
	return self

func asArray() -> Array:
	var resArray:Array
	resArray.append(money)
	resArray.append(food)
	resArray.append(energy)
	resArray.append(building_materials)
	resArray.append(consumer_goods)
	resArray.append(composites)
	return resArray
