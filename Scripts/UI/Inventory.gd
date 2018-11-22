extends WindowDialog

const empty_slot = preload("res://Sprites/Items/EmptySlot.png")

func _ready():
	for i in range(18):
		$ItemList.add_icon_item(empty_slot, false)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_inventory"):
		if visible:
			hide()
		else:
			show()