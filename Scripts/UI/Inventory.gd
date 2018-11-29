extends WindowDialog

const empty_slot = preload("res://Sprites/Items/EmptySlot.png")
const inventory_size = 18

# Colors for equipping
const equipped_color = Color(0, 0.7, 0, 0.5)
const unequipped_color = Color(0, 0, 0, 0)

# Item attached to the cursor
var cursor_item
var cursor_item_slot
var cursor_item_bg_color

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
		return
		
	if event is InputEventMouseButton:
		# Left button click
		if event.button_index == BUTTON_RIGHT and not event.pressed:
			if cursor_item != null:
				# Cancel moving operation
				set_item(cursor_item_slot, cursor_item, cursor_item_bg_color)
				_remove_item_from_cursor()
				return
			
			var slot = $ItemList.get_item_at_position($ItemList.get_local_mouse_position(), true)
			if slot != -1:
				equip(slot)
			return
			
		# Right button click
		if event.button_index == BUTTON_LEFT and not event.pressed:
			# Pick item from slot under mouse
			if cursor_item == null:
				var slot = $ItemList.get_item_at_position($ItemList.get_local_mouse_position(), true)
				if slot != -1:
					add_item_to_cursor(slot)
				return
			
			# Drop item if cursor is outside window
			var slot = $ItemList.get_item_at_position($ItemList.get_local_mouse_position(), true)
			if slot == -1:
				if not get_rect().has_point(get_viewport().get_mouse_position()):
					drop_item_from_cursor()
				return
			
			# Put item to slot under mouse
			put_item_from_cursor(slot)

func _remove_item_from_cursor():
	set_process(false)
	remove_child(cursor_item)
	cursor_item = null

func add_item(item):
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
					return true
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
		return false
	
	# Add item to this slot
	# Use dublicate since the item will be removed from the world
	set_item(new_slot, item.duplicate(), unequipped_color)
	return true

func set_item(slot, item, bg_color):
	if item != null:
		# Set item data
		$ItemList.set_item_icon(slot, item.get_node("Sprite").texture)
		$ItemList.set_item_metadata(slot, item)
		
		# Show count in text property
		if item.stackable():
			$ItemList.set_item_text(slot, str(item.count))
		else:
			$ItemList.set_item_text(slot, "")
	else:
		# Set empty slot
		$ItemList.set_item_icon(slot, empty_slot)
		$ItemList.set_item_metadata(slot, null)
		$ItemList.set_item_text(slot, "")
	
	# Set item bg color to mark item quipped / unequipped
	if bg_color != $ItemList.get_item_custom_bg_color(slot):
		$ItemList.set_item_custom_bg_color(slot, bg_color)
		$ItemList.update()

func add_item_to_cursor(slot):
	var slot_item = $ItemList.get_item_metadata(slot)
	if slot_item == null:
		return
	
	cursor_item = slot_item
	cursor_item_slot = slot
	cursor_item_bg_color = $ItemList.get_item_custom_bg_color(slot)
	set_item(slot, null, unequipped_color)
	add_child(cursor_item)
	set_process(true)

func put_item_from_cursor(slot):
	var slot_item = $ItemList.get_item_metadata(slot)
	if slot_item != null and slot_item.get_name() == cursor_item.get_name():
		# Try to add item to stack
		var items_in_slot = int($ItemList.get_item_text(slot))
		
		# Check if item fits to stack
		if items_in_slot + cursor_item.count <= cursor_item.stack:
			$ItemList.set_item_text(slot, str(items_in_slot + cursor_item.count))
			_remove_item_from_cursor()
		else:
			# Add the maximum quantity
			$ItemList.set_item_text(slot, str(cursor_item.stack))
			cursor_item.count -= cursor_item.stack - items_in_slot
	else:
		# Swap items
		var slot_color = $ItemList.get_item_custom_bg_color(slot)
		set_item(cursor_item_slot, slot_item, slot_color)
		set_item(slot, cursor_item, cursor_item_bg_color)
		_remove_item_from_cursor()

func drop_item_from_cursor():
	if cursor_item_bg_color == equipped_color:
		get_node("../../World/Objects/Player" + str(Global.id)).rpc("equip_weapon", null)
	rpc("drop_item", cursor_item.get_filename(), cursor_item.count, get_node("../../World/Objects/Player" + str(Global.id)).position)
	_remove_item_from_cursor()

func equip(slot):
	var item = $ItemList.get_item_metadata(slot)
	if item != null and item.is_in_group("Weapon"):
		# Equip / Unequip item
		if $ItemList.get_item_custom_bg_color(slot) == unequipped_color:
			get_node("../../World/Objects/Player" + str(Global.id)).rpc("equip_weapon", item.get_name())
			$ItemList.set_item_custom_bg_color(slot, equipped_color)
		else:
			get_node("../../World/Objects/Player" + str(Global.id)).rpc("equip_weapon", null)
			$ItemList.set_item_custom_bg_color(slot, unequipped_color)
		$ItemList.update() # Update window to show bg color

sync func drop_item(item_name, count, coordinats):
	var item = load(item_name).instance()
	item.position = coordinats
	item.count = count
	$"../../World/Objects".add_child(item)