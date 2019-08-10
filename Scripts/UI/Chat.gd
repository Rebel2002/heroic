extends Control

var history: Array
var history_position: int = 0

signal command_entered(command)

func _input(event: InputEvent) -> void:
	if $InputField.has_focus():
		if event.is_action_pressed("ui_cancel"):
			get_tree().set_input_as_handled()
			set_input_focused(false)
		elif event.is_action_pressed("chat_next"):
			get_tree().set_input_as_handled()
			if history_position < history.size() - 1:
				history[history_position] = $InputField.text
				history_position += 1
				$InputField.text = history[history_position]
				$InputField.set_cursor_position(history[history_position].length())
		elif event.is_action_pressed("chat_previous"):
			get_tree().set_input_as_handled()
			if history_position > 0:
				history[history_position] = $InputField.text
				history_position -= 1
				$InputField.text = history[history_position]
				$InputField.set_cursor_position(history[history_position].length())
	else:
		if event.is_action_pressed("ui_accept"):
			get_tree().set_input_as_handled()
			set_input_focused(true)

func _on_InputField_text_entered(message: String) -> void:
	if $InputField.text.empty():
		return
	
	if history.size() != 0 and history.front().empty():
		history[0] = message
	else:
		history.push_front(message)
	$InputField.text = ""
	history.push_front($InputField.text)
	history_position = 0
	
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