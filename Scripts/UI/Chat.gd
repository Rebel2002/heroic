extends Control

func _input(event: InputEvent) -> void:
	if not $InputField.has_focus() and event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		$InputField.grab_focus()
	elif $InputField.has_focus() and event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		grab_focus() # Remove focus from input field (just focus parent)

func _on_InputField_text_entered(new_text: String) -> void:
	if not $InputField.text.empty():
		$InputField.text = ""
		rpc("send_message", Global.id, new_text)

sync func send_message(id: int, text: String) -> void:
	get_node("../../World/Objects/Player" + str(id)).say(text)
	$ChatWindow.bbcode_text += "\n[color=green]" + Global.players[id]["game_name"] + "[/color]: " + text

sync func announce_connected(player_name: String) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has joined the game.[/color]" 

func announce_disconnected(player_name: String) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has left the game.[/color]" 
