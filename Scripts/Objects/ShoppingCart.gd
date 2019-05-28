tool
extends StaticBody2D

export(int, "Closed", "Open") var type setget set_type, get_type
export(Color, RGB) var roof_color setget set_roof_color, get_roof_color

func set_type(type: int) -> void:
	$Cart.frame = type

func get_type() -> int:
	return $Cart.frame

func set_roof_color(color: Color) -> void:
	$Roof.modulate = color

func get_roof_color() -> Color:
	return $Roof.modulate
