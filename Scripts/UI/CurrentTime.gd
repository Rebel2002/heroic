extends Control

var minute: int
var hour: int

signal time_changed(hour, minute)

func _ready() -> void:
	if get_tree().is_network_server():
		var time: Dictionary = OS.get_time()
		set_time(time.hour, time.minute)
		$MinuteTimer.wait_time = 60 - time.second
		$MinuteTimer.start()
		$MinuteTimer.wait_time = 60 # For next minutes

sync func set_time(hour: int, minute: int) -> void:
	self.hour = hour
	self.minute = minute
	$Time.text = "%02d:%02d" % [hour, minute]
	emit_signal("time_changed", hour, minute)

func _on_MinuteTimer_timeout() -> void:
	minute += 1
	if minute >= 60:
		minute = 0
		hour += 1
		if hour >= 24:
			hour = 0
	
	rpc("set_time", hour, minute)