tool
extends Node2D

export(int, 16) var door = 7 setget _set_door
export(int, 1) var stairs = 0 setget _set_stairs
export(int, -1, 4) var chimney = 1 setget _set_chimney
export(int, -1, 6) var window_flowers = 1 setget _set_window_flowers

func _ready():
	pass

func _set_door(value):
	door = value
	
	if (has_node("Door")):
		$Door.frame = value

func _set_stairs(value):
	stairs = value
	
	if (has_node("HouseStairs")):
		$HouseStairs/Sprite.frame = value

func _set_chimney(value):
	chimney = value
	
	if (has_node("Chimney")):
		if value == -1:
			$Chimney.visible = false
		else:
			$Chimney.frame = value
			$Chimney.visible = true

func _set_window_flowers(value):
	window_flowers = value
	
	if (has_node("WindowFlowers")):
		if value == -1:
			$WindowFlowers.visible = false
			$WindowFlowers2.visible = false
		else:
			$WindowFlowers.frame = value
			$WindowFlowers2.frame = value
			$WindowFlowers.visible = true
			$WindowFlowers2.visible = true
			