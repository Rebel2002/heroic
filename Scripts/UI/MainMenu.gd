extends Control

const quote_list: Array = ["Git Gud!", "Parase the Sun!", "Stallman approved!", "Press your eye sockets and kill yourself!",
		"Rip and Tear until it's done!", "Not like Dork Sous!"]

func _ready() -> void:
	randomize()
	$Panel/Buttons/NewGame.grab_focus()
	
	# Set random quote
	var quote: String = quote_list[randi() % quote_list.size()]
	$Quote.set("text", quote)
	$Quote/Animation.play("zoom")

func _on_NewGame_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/CreateCharacter.tscn")

func _on_Settings_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Settings.tscn")

func _on_Quit_pressed() -> void:
	get_tree().quit()