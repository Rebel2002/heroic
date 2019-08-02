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
	var arguments: PoolStringArray = command.split(' ', false)
	match arguments[0]:
		"/time":
			_set_time_command(arguments)
		"/kill":
			_kill_command(arguments)
		"/noclip":
			_noclip_command()
		"/tp":
			_teleport_command(arguments)
		"/pos":
			_show_position_command()
		"/spawn":
			_spawn_command(arguments)

sync func drop_item(item_name: String, count: int, coordinats: Vector2) -> void:
	var item = load(item_name).instance()
	item.position = coordinats
	item.count = count
	$World/Objects.add_child(item)

func _is_arguments_count(arguments: PoolStringArray, expected_size: int) -> bool:
	if arguments.size() != expected_size:
		$Ui/Chat.show_information("Invalid number of arguments")
		return false
	return true

func _set_time_command(arguments: PoolStringArray) -> void:
	if not _is_arguments_count(arguments, 2):
		return
		
	var time: PoolStringArray = arguments[1].split(':', false)
	if time.size() != 2:
		$Ui/Chat.show_information("Invalid time: %s" % arguments[1])
		return
		
	$Ui/CurrentTime.rpc("set_time", int(time[0]), int(time[1]))
	$Ui/Chat.show_information("Time was changed to %s" % arguments[1])

func _kill_command(arguments: PoolStringArray) -> void:
	if not _is_arguments_count(arguments, 2):
		return
	
	var id = int(arguments[1])
	if not Global.players.has(id):
		$Ui/Chat.show_information("Unable to find player with id: %s" % arguments[1])
		return
	
	Global.players[id].health = 0

func _noclip_command() -> void:
	var collision: CollisionShape2D = Global.players[Global.id].get_node("Collision")
	collision.disabled = not collision.disabled

func _teleport_command(arguments: PoolStringArray) -> void:
	if not _is_arguments_count(arguments, 4):
		return
	
	var id = int(arguments[1])
	if not Global.players.has(id):
		$Ui/Chat.show_information("Unable to find player with id: %s" % arguments[1])
		return
	
	Global.players[id].position = Vector2(int(arguments[2]), int(arguments[3]))

func _show_position_command() -> void:
	var position: Vector2 = Global.players[Global.id].position
	$Ui/Chat.show_information("Current position: %.2f %.2f" % [position.x, position.y])

func _spawn_command(arguments: PoolStringArray) -> void:
	if not _is_arguments_count(arguments, 4):
		return
	
	var scene: PackedScene = load("res://Scenes/Creatures/%s.tscn" % arguments[1])
	if scene == null:
		$Ui/Chat.show_information("Unable to find creature with name: %s" % arguments[1])
		return
	
	var creature: Node2D = scene.instance()
	creature.position = Vector2(float(arguments[2]), float(arguments[3]))
	$World/Objects.add_child(creature)