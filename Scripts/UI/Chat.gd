extends Control

signal command_entered(command)

func _input(event: InputEvent) -> void:
	if not $InputField.has_focus() and event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		set_input_focused(true)
	elif $InputField.has_focus() and event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		set_input_focused(false)

func _on_InputField_text_entered(message: String) -> void:
	if $InputField.text.empty():
		return
	
	$InputField.text = ""
	set_input_focused(false)
	
	# Check if user execute command
	if message.begins_with('/') and is_network_master():
		emit_signal("command_entered", message)
		return
	rpc("send_message", Global.id, message)

sync func send_message(id: int, message: String) -> void:
	Global.players[id].say(message)
	$ChatWindow.bbcode_text += "\n[color=green]" + Global.players[id].game_name + "[/color]: " + message

func show_information(message: String) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + message + "[/color]" 

sync func announce_connected(player_name: String) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has joined the game.[/color]" 

func announce_disconnected(player_name: String) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has left the game.[/color]"

func set_input_focused(focused: bool) -> void:
	if focused:
		$InputField.grab_focus()
	else:
		grab_focus() # Remove focus from input field (just focus parent)