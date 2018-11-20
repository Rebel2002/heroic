extends WindowDialog

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_inventory"):
		if visible:
			hide()
		else:
			show()