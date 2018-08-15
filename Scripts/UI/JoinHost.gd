extends Control

func _ready():
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	
func _on_Join_pressed():
	if (not $Panel/Data/Ip.text.is_valid_ip_address()):
		$Panel/Status.text="Invalid Ipv4 address!"
		return
	Global.ip = $Panel/Data/Ip.text
	
	# Disable buttons
	$Panel/Join.disabled = true
	$Panel/Host.disabled = true
	
	# Connect
	var host = NetworkedMultiplayerENet.new()
	host.create_client(Global.ip, Global.port)
	get_tree().set_network_peer(host)
	$ConnectionTimer.start()

func _on_Host_pressed():
	# Create server
	var host = NetworkedMultiplayerENet.new()
	host.create_server(Global.port)
	get_tree().set_network_peer(host)
	get_tree().change_scene("res://Scenes/Core/Main.tscn")

# Callback from SceneTree, only for clients (not server)
func _on_connected_to_server():
	get_tree().change_scene("res://Scenes/Core/Main.tscn")

# Callback from SceneTree, only for clients (not server)
func _on_connection_failed():
	get_tree().set_network_peer(null) # Remove peer
	
	# Restore interface
	$Panel/Join.disabled = false
	$Panel/Host.disabled = false
	$Panel/Status.text = "Connection failed."