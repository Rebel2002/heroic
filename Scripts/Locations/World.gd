extends WorldEnvironment

export(bool) var enable_lights setget set_enable_lights

func set_time(time: Dictionary) -> void:
	# Set visibility
	var minutes: int = time.hour * 60 + time.minute
	if time.hour >= 4 and time.hour < 6:
		environment.tonemap_exposure = 0.007 * minutes - 1.52
		self.enable_lights = true
	elif time.hour >= 6 and time.hour < 19:
		environment.tonemap_exposure = 1
		self.enable_lights = false
	elif time.hour >= 19 and time.hour < 21:
		environment.tonemap_exposure = 8.98 - 0.007 * minutes
		self.enable_lights = false
	elif time.hour >= 21 or time.hour < 4:
		environment.tonemap_exposure = 0.16
		self.enable_lights = true

func set_enable_lights(enable: bool) -> void:
	if enable_lights == enable:
		return
	
	enable_lights = enable
	for node in $Objects.get_children():
		if not node.has_method("set_enable_light"):
			continue
		
		if node.enable_light != enable:
			node.enable_light = enable