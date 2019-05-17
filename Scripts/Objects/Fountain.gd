tool
extends StaticBody2D

export(String, "Open", "Closed") var type = "Open" setget set_type

func set_type(name: String) -> void:
	type = name
	$Sprite.texture = load("res://Sprites/Objects/Fountain/" + name + ".png")