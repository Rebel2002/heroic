extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if is_visible_in_tree():
			visible = false
		else:
			visible = true

func _on_MainMenu_pressed() -> void:
	get_tree().set_network_peer(null)
	Global.players.clear()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")

func _on_Quit_pressed() -> void:
	get_tree().quit()
