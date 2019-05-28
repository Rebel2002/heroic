tool
extends StaticBody2D

export(int, "Closed", "Open") var type setget set_type, get_type

func set_type(type: int) -> void:
	$Cart.frame = type

func get_type() -> int:
	return $Cart.frame
