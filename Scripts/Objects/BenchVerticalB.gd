tool
extends StaticBody2D

export(bool) var flipped setget set_flipped, get_flipped

func set_flipped(flipped: bool):
	$Sprite.flip_h = flipped

func get_flipped() -> int:
	return $Sprite.flip_h