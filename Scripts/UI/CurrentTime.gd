extends Control

signal time_changed(time)

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

func _on_MinuteTimer_timeout() -> void:
	var time: Dictionary = OS.get_time()
	emit_signal("time_changed", time)
	rpc("set_time", time)
