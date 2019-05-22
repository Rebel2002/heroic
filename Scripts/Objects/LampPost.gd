tool
extends StaticBody2D

export(bool) var enabled = false setget set_enabled

func set_enabled(value: bool) -> void:
	enabled = value
	$Lamp/Light.enabled = enabled
	if enabled:
		$Lamp/Animation.play("Lighting")
	else:
		$Lamp/Animation.stop()
		$Lamp/Lamp.frame = 0