tool
extends Area2D

export(String) var game_name = "" setget set_name
export(int) var stack = 1
export(int) var count = 1

sync func pick():
	queue_free()

func stackable():
	return stack != 1

func set_name(name):
	game_name = name
	if has_node("Name"):
		$Name.text = name + " (" + str(count) + ")"