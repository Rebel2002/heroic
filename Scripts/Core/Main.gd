extends Node

func _ready() -> void:
	Global.id = get_tree().get_network_unique_id()
	rpc("add_player", Global.id, Global.player) # Will call only server and local!
	get_tree().connect("network_peer_disconnected", self, "remove_player")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

sync func add_player(id: int, data: Dictionary) -> void:
	if get_tree().is_network_server() and id != 1:
		# Send server time
		$Ui/CurrentTime.rpc_id(id, "set_time", OS.get_time())
		
		for peer_id in Global.players:
			# Send all players data to new player
			rpc_id(id, "add_player", peer_id, Global.players[peer_id])
			if peer_id != 1:
				# Send new player data to all players except server
				rpc_id(peer_id, "add_player", id, data)
		$Ui/Chat.rpc("announce_connected", data["game_name"])
	
	# Load player
	Global.players[id] = data
	var player = load("res://Scenes/Creatures/Player.tscn").instance()
	player.set_network_master(id)
	player.set_name("Player" + str(id))
	player.set_data(data)
	$World/Objects.add_child(player)
	
func remove_player(id: int) -> void:
	$Ui/Chat.announce_disconnected(Global.players[id]["game_name"])
	Global.players.erase(id)
	get_node("World/Objects/Player" + str(id)).queue_free()

func _on_server_disconnected() -> void:
	OS.alert("Server closed connection")
	$Ui/GameMenu._on_MainMenu_pressed()

func execute_command(command: String) -> void:
	var parsed_command = command.split(' ', false)
	match parsed_command[0]:
		"/time":
			if parsed_command.size() != 2:
				$Ui/Chat.show_information("Invalid number of arguments")
				
			var parsed_time = parsed_command[1].split(':', false)
			if parsed_time.size() != 2:
				$Ui/Chat.show_information("Invalid time: " + parsed_command[1])
				return
				
			var time: Dictionary
			time.hour = int(parsed_time[0])
			time.minute = int(parsed_time[1])
			$Ui/CurrentTime.rpc("set_time", time)
			$Ui/Chat.show_information("Time was changed to " + parsed_command[1])

sync func drop_item(item_name: String, count: int, coordinats: Vector2) -> void:
	var item = load(item_name).instance()
	item.position = coordinats
	item.count = count
	$World/Objects.add_child(item)