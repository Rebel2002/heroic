extends WindowDialog

const empty_slot = preload("res://Sprites/Items/EmptySlot.png")
const inventory_size = 18

func _ready():
	# Fill inventory with empty slots
	for i in range(inventory_size):
		$ItemList.add_icon_item(empty_slot, false)

func _process(delta):
	# Show / hide inventory hotkey
	if Input.is_action_just_pressed("ui_inventory"):
		if visible:
			hide()
		else:
			show()

func add_item(item):
	#  Try to add to stack first
	if item.stackable():
		for i in range($ItemList.get_item_count()):
			# Find the first such item
			if ($ItemList.get_item_metadata(i) != null 
			and $ItemList.get_item_metadata(i).get_name() == item.get_name()):
				var items_in_slot = int($ItemList.get_item_text(i))
				
				# Continue if stack is already full
				if items_in_slot == item.stack:
					continue
				
				# Check if items fits to stack
				if items_in_slot + item.count <= item.stack:
					$ItemList.set_item_text(i, str(items_in_slot + item.count))
					item.rpc("pick") # Item added, pick it up from the world
					return
				else:
					# Add the maximum quantity to the slot and continue the search
					$ItemList.set_item_text(i, str(item.stack))
					item.count -= item.stack - items_in_slot
	
	# Find first empty slot
	var new_slot
	for i in range($ItemList.get_item_count()):
		if $ItemList.get_item_metadata(i) == null:
			new_slot = i
			break

	# Check if inventory is full
	if new_slot == null:
		print("Inventory is full")
		return

	# Add item to this slot
	$ItemList.set_item_icon(new_slot, item.get_node("Sprite").texture)
	$ItemList.set_item_metadata(new_slot, item)
	if item.stackable():
		$ItemList.set_item_text(new_slot, str(item.count))
	
	# Item added, pick it up from the world
	item.rpc("pick")