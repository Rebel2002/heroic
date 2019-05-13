extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = !visible

func _on_MainMenu_pressed() -> void:
	get_tree().set_network_peer(null)
	Global.players.clear()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")

func _on_Quit_pressed() -> void:
	get_tree().quit()
