extends Node

func _ready():
	Global.id = get_tree().get_network_unique_id()
	rpc("add_player", Global.id, Global.player) # Will call only server and local!
	get_tree().connect("network_peer_disconnected", self, "remove_player")
	get_tree().connect("server_disconnected", self, "disconnect")

sync func add_player(id, data):
	if get_tree().is_network_server() and id != 1:
		# Send server time
		$Ui/CurrentTime.rpc_id(id, "set_time", OS.get_time())
		
		for peer_id in Global.players:
			# Send all players data to new player
			rpc_id(id, "add_player", peer_id, Global.players[peer_id])
			if peer_id != 1:
				# Send new player data to all players except server
				rpc_id(peer_id, "add_player", id, data)
		$Ui/Chat.rpc("announce_connected", data["nickname"])
	
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
	$Ui/Chat.announce_disconnected(Global.players[id]["nickname"])
	Global.players.erase(id)
	get_node("World/Objects/Player" + str(id)).queue_free()

func disconnect():
	OS.alert("Server closed connection")
	$Ui/GameMenu._on_MainMenu_pressed()