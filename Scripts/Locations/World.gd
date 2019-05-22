extends WorldEnvironment

func set_time(time: Dictionary) -> void:
	# Set visibility
	var minutes: int = time.hour * 60 + time.minute
	if time.hour >= 4 && time.hour < 6:
		environment.tonemap_exposure = 0.007 * minutes - 1.52
	elif time.hour >= 6 && time.hour < 19:
		environment.tonemap_exposure = 1
	elif time.hour >= 19 && time.hour < 21:
		environment.tonemap_exposure = 8.98 - 0.007 * minutes
	elif time.hour >= 21 || time.hour < 4:
		environment.tonemap_exposure = 0.16
