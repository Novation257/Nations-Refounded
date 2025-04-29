extends Node

var network = ENetMultiplayerPeer.new()
var port = 3234
var max_players = 8

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_multiplayer_peer(network)
	network.connect("peer_connected", Callable(self, "_player_connected"))
	network.connect("peer_disconnected", Callable(self, "_player_disconnected"))
	
	print("Server connected.")
	
func _player_connected(id):
	print("Player: " + str(id) + " Connected.")
	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disonnected.")
