extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		$InputField.grab_focus()

func _on_InputField_text_entered(new_text: String) -> void:
	if not $InputField.text.empty():
		$InputField.text = ""
		rpc("send_message", Global.id, new_text)

sync func send_message(id, new_text) -> void:
	get_node("../../World/Objects/Player" + str(id)).say(new_text)
	$ChatWindow.bbcode_text += "\n[color=green]" + Global.players[id]["nickname"] + "[/color]: " + new_text

sync func announce_connected(player_name) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has joined the game.[/color]" 

func announce_disconnected(player_name) -> void:
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has left the game.[/color]" 