tool
extends Area2D
class_name Item

export(String) var game_name = "" setget set_game_name
export(int) var stack = 1
export(int) var count = 1

var equipped: bool = false

sync func pick() -> void:
	queue_free()

func stackable() -> bool:
	return stack != 1

func set_game_name(new_name: String) -> void:
	game_name = new_name
	if has_node("Name"):
		if stackable():
			$Name.text = new_name + " (" + str(count) + ")"
		else:
			$Name.text = new_name