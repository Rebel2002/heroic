tool
extends StaticBody2D

export(int, "Stone", "Wood") var type setget set_type

func set_type(value: int) -> void:
	type = value
	$Sprite.frame = type