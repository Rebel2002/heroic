extends Humanoid

var user_input: bool = true setget set_user_input

enum {NONE, WALKING, ATTACKING}

func _ready() -> void:
	if is_network_master():
		$Camera.make_current()

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	# Make actions
	get_input()
	match current_action:
		WALKING:
			$Animation.play_directional_animation("Walk")
			move_and_collide(velocity * delta)
		ATTACKING:
			$Animation.play_directional_animation("MeleeAttack")
		NONE:
			$Animation.stop()

# Read pressed keys
func get_input() -> void:
	if not is_network_master() or not user_input:
		return
		
	# Pick an item
	if Input.is_action_just_pressed("ui_pickup"):
		for object in $InterractArea.get_overlapping_areas():
			if object.is_in_group("Item") and get_node("../../../Ui/Inventory").add_item(object):
				# Item added, pick it up from the world
				object.rpc("pick")
	
	# Change the player's vector depending on the keys
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	# Normalize vector
	if velocity == Vector2.ZERO:
		current_action = NONE
	else:
		current_action = WALKING
		self.velocity = velocity.normalized() * speed
	
	if (Input.is_action_just_pressed("ui_attack")
			or $Animation.current_animation.begins_with("MeleeAttack")):
		current_action = ATTACKING
	
	# Send input via network
	rset("current_action", current_action)
	rset("velocity", velocity)
	rpc_unreliable("set_position", position) # Send position to avoid desync

func set_user_input(enable: bool) -> void:
	user_input = enable