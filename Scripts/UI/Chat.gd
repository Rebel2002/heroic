extends Control

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$InputField.grab_focus()

func _on_InputField_text_entered(new_text):
	if $InputField.text != "":
		$InputField.text = ""
		rpc("send_message", Global.id, new_text)

sync func send_message(id, new_text):
	get_node("../../World/Objects/Player" + str(id)).say(new_text)
	$ChatWindow.bbcode_text += "\n[color=green]" + Global.players[id]["nickname"] + "[/color]: " + new_text

sync func announce_connected(player_name):
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has joined the game.[/color]" 

func announce_disconnected(player_name):
	$ChatWindow.bbcode_text += "\n[color=gray]" + player_name + " has left the game.[/color]" 