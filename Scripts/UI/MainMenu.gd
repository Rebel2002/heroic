extends Control

var quote_list = ["Git Gud!", "Parase the Sun!",
 "Stallman approved!", "Press your eye sockets and kill yourself!",
"Rip and Tear until it's done!", "Not like Dork Sous!"]

func _ready():
	randomize()
	var quote = quote_list[randi() % quote_list.size()]
	$Quote.set("text", quote)
	$Quote/Animation.play("zoom")
	$Panel/Buttons/NewGame.grab_focus()

func _on_NewGame_pressed():
	get_tree().change_scene("res://Scenes/UI/CreateCharacter.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://Scenes/UI/Settings.tscn")

func _on_Quit_pressed():
	get_tree().quit()