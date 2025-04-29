extends Node2D
class_name Unit

# unit variables like health and attack stats, can change if need be
var id:int
var owner_id:int
var target_position:Vector2
var move_speed:float = 100.0
var health:int = 100
var attack:int = 20
var defense:int = 10
var in_combat:bool = false
var target_unit:Unit = null
var inside_city:City = null
var selected:bool = false

# For UI, can change depending on which node would be the right one to get
@onready var master = get_tree().get_root().get_node("Master Node")

# Build cost, can be changed
const UNIT_COST:int = 100

# For movement
var path:Array = []

# Signals
signal unit_conquered_city(city:City)

func _ready() -> void:
    pass

func _process(delta:float) -> void:
    if path.size() > 0:
        move_along_path(delta)
    if in_combat and target_unit:
        engage_combat(delta)

# Movement
func move_along_path(delta:float) -> void:
    if path.size() == 0:
        return

    var next_pos = path[0]
    var direction = (next_pos - global_position).normalized()
    global_position += direction * move_speed * delta

    if global_position.distance_to(next_pos) < 10:
        path.pop_front()

    # Check city conquering if reached target
    if inside_city and inside_city.get_meta("ownerID") != owner_id:
        conquer_city()

# Choose where to go
func move_to(position:Vector2) -> void:
    path.clear()
    path.append(position)
    target_position = position

# Start combat with another unit
func attack_unit(enemy:Unit) -> void:
    if enemy.owner_id == owner_id:
        return # Cannot attack your own units
    in_combat = true
    target_unit = enemy

func engage_combat(delta:float) -> void:
    if not target_unit or not is_instance_valid(target_unit):
        in_combat = false
        return

    # Damage, can also be changed if need be
    var damage_dealt = max(0, attack - target_unit.defense)
    target_unit.health -= damage_dealt * delta
    if target_unit.health <= 0:
        target_unit.queue_free()
        target_unit = null
        in_combat = false

# Executes when in a city, conquers it
func conquer_city() -> void:
    if inside_city and inside_city.get_meta("ownerID") != owner_id:
        inside_city.set_meta("ownerID", owner_id)
        inside_city.UI_ownerID.text = "OwnerID: " + str(owner_id)
        emit_signal("unit_conquered_city", inside_city)
        master.staticUI.notify("City conquered!")
        inside_city = null

# Checks to see if unit is actually inside city
func check_city_collision(city:City) -> void:
    if global_position.distance_to(city.global_position) < 100: # or adjust threshold
        inside_city = city
    else:
        inside_city = null

# Create a unit
func create_unit(owner:int, position:Vector2) -> Unit:
    if master.money >= UNIT_COST:
        master.money -= UNIT_COST
        var new_unit = Unit.new()
        new_unit.owner_id = owner
        new_unit.global_position = position
        master.add_child(new_unit)
        return new_unit
    else:
        master.staticUI.notify("Not enough money to create unit!")
        return null

# Handles user input for setting move destination
func _input(event:InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and selected:
        if event.button_index == MOUSE_BUTTON_RIGHT:
            move_to(get_global_mouse_position())
