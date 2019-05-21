tool
extends Sprite

export(int, 9) var type setget set_type

func set_type(value: int) -> void:
	type = value
	frame = type