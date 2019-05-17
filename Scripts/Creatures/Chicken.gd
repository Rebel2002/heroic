extends Creature

enum {NONE, WALKING, EATING}

func _ready() -> void:
	if get_tree().is_network_server():
		make_random_action()
	
func _physics_process(delta: float) -> void:
	if get_tree().is_network_server():
		rpc_unreliable("set_position", position) # Send position to avoid desync
	
	match current_action:
		NONE:
			$Animation.stop()
		WALKING:
			# Try to move in random direction
			if move_and_collide(velocity * delta) != null:
				if get_tree().is_network_server():
					randomize_velocity() # Change direction if creature collides
			else:
				$Animation.play_directional_animation("Walk") # If moving successful
		EATING:
			$Animation.play_directional_animation("Eat")

# Transformate into a backed chicken when dying
remote func set_health(value: int) -> void:
	if value > 0:
		.set_health(value)
	else:
		get_node("../../..").rpc("drop_item", "res://Scenes/Items/BackedChicken.tscn", 1, position)
		rpc("remove")

func make_random_action() -> void:
	current_action = randi() % 3
	rset("current_action", current_action)
	
	# Setup next random action time
	match current_action:
		NONE:
			$RandomActionTimer.wait_time = 1
		WALKING:
			$RandomActionTimer.wait_time = randi() % 5 + 2
			randomize_velocity()
		EATING:
			$RandomActionTimer.wait_time = randi() % 2 + 1
	
	$RandomActionTimer.start()

# Generate random movement
func randomize_velocity() -> void:
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	self.velocity = velocity.normalized() * speed / 2
	if velocity == Vector2.ZERO:
		randomize_velocity() # If generated velocity is equal to zero
	else:
		rset("velocity", velocity)