tool
extends Node2D

export(int, 2) var type setget set_type, get_type

func set_type(type: int):
	$Sprite.frame = type

func get_type() -> int:
	return $Sprite.frame
