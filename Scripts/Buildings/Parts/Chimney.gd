tool
extends Sprite

export(int, "Brown", "Red", "Gray", "White") var type setget set_type

func set_type(value: int) -> void:
	type = value
	frame = type