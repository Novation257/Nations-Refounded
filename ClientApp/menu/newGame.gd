extends Button

@onready var root = get_parent().get_parent()
@onready var menu = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	# Change text to loading
	self.text = "Loading..."
	await get_tree().create_timer(0.1).timeout
	
	# Load master scene and instanciate
	var masterSceneRes:Resource = load("res://masterScene.tscn")
	var masterScene:Master = masterSceneRes.instantiate()
	root.add_child(masterScene)
	menu.queue_free()
	
	#Clear Placed Objects
	for city in masterScene.get_node("%Cities").get_children():
		city.queue_free()
	for extractor in masterScene.get_node("%Extractors").get_children():
		extractor.queue_free()
	
	masterScene.curr_player.resources.money = 20000
	masterScene.curr_player.resources.food = 10000
	masterScene.curr_player.resources.energy = 2500
	masterScene.curr_player.resources.building_materials = 10000
	masterScene.curr_player.resources.consumer_goods = 0
	masterScene.curr_player.resources.composites = 0
	
	
	pass # Replace with function body.
