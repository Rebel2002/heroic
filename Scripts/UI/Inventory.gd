extends WindowDialog

const empty_slot = preload("res://Sprites/Items/EmptySlot.png")
const potato = preload("res://Scenes/Items/Potato.tscn")
const inventory_size = 18

var cursor_item
var cursor_item_slot

func _ready():
	# Fill inventory with empty slots
	for i in range(inventory_size):
		$ItemList.add_icon_item(empty_slot, false)
	
	# Disable process by default for perfomance
	set_process(false)

# Move item by cursor
func _process(delta):
	cursor_item.global_position = get_viewport().get_mouse_position()

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		# Show / hide inventory
		if visible:
			hide()
		else:
			show()
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and not event.pressed:
			print(123)
			# Left button click
			if cursor_item != null:
				# Cancel moving operation
				set_item(cursor_item_slot, cursor_item)
				remove_item_from_cursor()
		elif event.button_index == BUTTON_LEFT and not event.pressed:
			# Right button click
			if cursor_item == null:
				# Pick item from slot under mouse
				var slot = $ItemList.get_item_at_position($ItemList.get_local_mouse_position(), true)
				if slot == -1:
					return
				
				var slot_item = $ItemList.get_item_metadata(slot)
				if slot_item != null:
					# Move item from slot to cursor
					cursor_item_slot = slot
					add_item_to_cursor(slot_item)
					set_item(slot, null)
			else:
				# Put item to slot under mouse
				var slot = $ItemList.get_item_at_position($ItemList.get_local_mouse_position(), true)
				if slot == -1:
					return
				
				var slot_item = $ItemList.get_item_metadata(slot)
				if slot_item != null and slot_item.get_name() == cursor_item.get_name():
					# Try to add item to stack
					var items_in_slot = int($ItemList.get_item_text(slot))
					
					# Check if item fits to stack
					if items_in_slot + cursor_item.count <= cursor_item.stack:
						$ItemList.set_item_text(slot, str(items_in_slot + cursor_item.count))
						remove_item_from_cursor()
					else:
						# Add the maximum quantity
						$ItemList.set_item_text(slot, str(cursor_item.stack))
						cursor_item.count -= cursor_item.stack - items_in_slot
				else:
					# Swap items
					set_item(cursor_item_slot, slot_item)
					set_item(slot, cursor_item)
					remove_item_from_cursor()

func pick_item(item):
	#  Try to add to stack first
	if item.stackable():
		for i in range($ItemList.get_item_count()):
			# Find the first such item
			if ($ItemList.get_item_metadata(i) != null 
			and $ItemList.get_item_metadata(i).get_name() == item.get_name()):
				var items_in_slot = int($ItemList.get_item_text(i))
				if items_in_slot == item.stack:
					continue # Stack is full
				
					# Check if item fits to stack
				if items_in_slot + item.count <= item.stack:
					$ItemList.set_item_text(i, str(items_in_slot + item.count))
					item.rpc("pick") # Item added, pick it up from the world
					return
				else:
					# Add maximum quantity to slot and continue search
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
	# Use dublicate since the item will be removed from the world
	set_item(new_slot, item.duplicate())
	
	# Item added, pick it up from the world
	item.rpc("pick")

func set_item(slot, item):
	if item != null:
		# Set item data
		$ItemList.set_item_icon(slot, item.get_node("Sprite").texture)
		$ItemList.set_item_metadata(slot, item)
		if item.stackable():
			$ItemList.set_item_text(slot, str(item.count))
	else:
		# Set empty slot
		$ItemList.set_item_icon(slot, empty_slot)
		$ItemList.set_item_metadata(slot, null)
		$ItemList.set_item_text(slot, "")

func add_item_to_cursor(item):
	cursor_item = item
	add_child(cursor_item)
	set_process(true)

func remove_item_from_cursor():
	set_process(false)
	remove_child(cursor_item)
	cursor_item = null