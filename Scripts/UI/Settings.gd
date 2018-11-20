extends Control

func _ready():
	pass

func _on_Cancel_pressed():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")

func _on_Apply_pressed():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
