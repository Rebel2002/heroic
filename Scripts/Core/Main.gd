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
			rpc_id(id, "add_player", peer_id, Global.players[peer_id].data())
			if peer_id != 1:
				# Send new player data to all players except server
				rpc_id(peer_id, "add_player", id, data)
		$Ui/Chat.rpc("announce_connected", data["game_name"])
	
	# Load player
	var player = load("res://Scenes/Creatures/Player.tscn").instance()
	player.set_network_master(id)
	player.set_name("Player" + str(id))
	player.set_data(data)
	Global.players[id] = player
	$World/Objects.add_child(player)
	
	if is_network_master():
		$Ui/Chat/InputField.connect("focus_entered", player, "set_user_input", [false])
		$Ui/Chat/InputField.connect("focus_exited", player, "set_user_input", [true])

func remove_player(id: int) -> void:
	$Ui/Chat.announce_disconnected(Global.players[id].game_name)
	Global.players.erase(id)
	get_node("World/Objects/Player" + str(id)).queue_free()

func _on_server_disconnected() -> void:
	OS.alert("Server closed connection")
	$Ui/GameMenu._on_MainMenu_pressed()

func execute_command(command: String) -> void:
	var parsed_command: PoolStringArray = command.split(' ', false)
	match parsed_command[0]:
		"/time":
			if parsed_command.size() != 2:
				$Ui/Chat.show_information("Invalid number of arguments")
				return
				
			var parsed_time: PoolStringArray = parsed_command[1].split(':', false)
			if parsed_time.size() != 2:
				$Ui/Chat.show_information("Invalid time: %s" % parsed_command[1])
				return
				
			var time: Dictionary
			time.hour = int(parsed_time[0])
			time.minute = int(parsed_time[1])
			$Ui/CurrentTime.rpc("set_time", time)
			$Ui/Chat.show_information("Time was changed to %s" % parsed_command[1])
		"/kill":
			if parsed_command.size() != 2:
				$Ui/Chat.show_information("Invalid number of arguments")
				return
			
			var id = int(parsed_command[1])
			if not Global.players.has(id):
				$Ui/Chat.show_information("Unable to find player with id: %s" % parsed_command[1])
				return
			
			Global.players[id].health = 0
		"/noclip":
			var collision: CollisionShape2D = Global.players[Global.id].get_node("Collision")
			collision.disabled = not collision.disabled
		"/tp":
			if parsed_command.size() != 4:
				$Ui/Chat.show_information("Invalid number of arguments")
				return
			
			var id = int(parsed_command[1])
			if not Global.players.has(id):
				$Ui/Chat.show_information("Unable to find player with id: %s" % parsed_command[1])
				return
			
			Global.players[id].position = Vector2(int(parsed_command[2]), int(parsed_command[3]))
		"/pos":
			var position: Vector2 = Global.players[Global.id].position
			$Ui/Chat.show_information("Current position: %.2f %.2f" % [position.x, position.y])

sync func drop_item(item_name: String, count: int, coordinats: Vector2) -> void:
	var item = load(item_name).instance()
	item.position = coordinats
	item.count = count
	$World/Objects.add_child(item)