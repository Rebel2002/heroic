extends Node

func _ready():
	Global.id = get_tree().get_network_unique_id()
	rpc("add_player", Global.id, Global.player)
	$Chat.rpc("announce_connected", Global.player["nickname"])
	get_tree().connect("network_peer_disconnected", self, "remove_player")

sync func add_player(id, data):
	# If I'm the server, send the info of existing players to new
	if get_tree().is_network_server():
		for peer_id in Global.players:
			rpc_id(id, "add_player", peer_id, Global.players[peer_id])
	
	# Load player
	Global.players[id] = data
	var player = load("res://Scenes/Creatures/Player.tscn").instance()
	player.set_network_master(id)
	player.set_name("Player" + str(id))
	player.game_name = data["nickname"]
	player.sex = data["sex"]
	player.race = data["race"]
	player.skintone = data["skintone"]
	player.hair = data["hair"]
	player.hair_color = data["hair_color"]
	player.eyes = data["eyes"]
	player.load_sprite()
	$World/Objects.add_child(player)
	
func remove_player(id):
	$Chat.announce_disconnected(Global.players[id]["nickname"])
	Global.players.erase(id)
	get_node("World/Objects/Player" + str(id)).queue_free()

func _process(delta):
	pass