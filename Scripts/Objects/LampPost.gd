tool
extends StaticBody2D

export(bool) var enable_light = false setget set_enable_light

func set_enable_light(enable: bool) -> void:
	enable_light = enable
	$Lamp/Light.enabled = enable_light
	if enable_light:
		$Lamp/Animation.play("Lighting")
	else:
		$Lamp/Animation.stop()
		$Lamp.frame = 0