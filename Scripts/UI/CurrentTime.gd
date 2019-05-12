extends Control

func _ready() -> void:
	if get_tree().is_network_server():
		set_time(OS.get_time())
		$MinuteTimer.wait_time = 60 - OS.get_time().second
		$MinuteTimer.start()
		$MinuteTimer.wait_time = 60 # For next minutes

sync func set_time(time: Dictionary) -> void:
	var timeString
	
	# Set hours
	if time.hour < 10:
		timeString = "0" + str(time.hour)
	else:
		timeString = str(time.hour)
	
	timeString += ":"
	
	# Set minutes
	if time.minute < 10:
		timeString += "0" + str(time.minute)
	else:
		timeString += str(time.minute)
	
	$Time.text = timeString
	
	# Set visibility
	var minutes: int = time.hour * 60 + time.minute
	if time.hour >= 4 && time.hour < 6:
		$"../../World".environment.tonemap_exposure = 0.007 * minutes - 1.52
	elif time.hour >= 6 && time.hour < 19:
		$"../../World".environment.tonemap_exposure = 1
	elif time.hour >= 19 && time.hour < 21:
		$"../../World".environment.tonemap_exposure = 8.98 - 0.007 * minutes
	elif time.hour >= 21 || time.hour < 4:
		$"../../World".environment.tonemap_exposure = 0.16

func _on_MinuteTimer_timeout() -> void:
		rpc("set_time", OS.get_time())
