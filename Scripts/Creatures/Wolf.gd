extends "res://Scripts/Creatures/Creature.gd"

remote var current_target
enum {NONE, WALKING, HOWLING, RUNNING}

func _ready():
	if get_tree().is_network_server():
		make_random_action()
	
func _process(delta):
	if get_tree().is_network_server():
		rpc_unreliable("set_position", position) # Send position to avoid desync
	
	if current_action == WALKING:
		# Try to move in random direction
		if (move_and_collide(velocity * delta) != null):
			if get_tree().is_network_server():
				randomize_velocity() # Change direction if creature collides
		else:
			play_animation("Walk") # If moving successful
	elif current_action == RUNNING:
		if get_tree().is_network_server():
			velocity = to_local(current_target.position).normalized() * speed
			rset("velocity", velocity)
			calculate_direction()
		play_animation("Run")
		move_and_collide(velocity * delta)

remote func synchronize_data(id):
	.synchronize_data(id)
	
	if current_target != null:
		rset_id(id, "current_target", current_target)

sync func stop_animation():
	$Body/Animation.stop()
	match direction:
		UP:
			$Body.set_frame(5)
		LEFT:
			$Body.set_frame(15)
		DOWN:
			$Body.set_frame(0)
		RIGHT:
			$Body.set_frame(10)

func make_random_action():
	var time = OS.get_time().hour
	
	# Set NONE, WALKING or HOWLING
	if time > 21 || time < 4:
		current_action = randi() % 3
	else:
		current_action = randi() % 2
	rset("current_action", current_action)
	
	match current_action:
		NONE:
			rpc("stop_animation")
			$RandomActionTimer.wait_time = 1
		WALKING:
			randomize_velocity()
			$RandomActionTimer.wait_time = randi() % 5 + 2
		HOWLING:
			rpc("play_animation", "Howl")
			$RandomActionTimer.wait_time = 1.8
	
	$RandomActionTimer.start()

# Generate random movement
func randomize_velocity():
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	velocity = velocity.normalized() * speed / 2
	if velocity.length() != 0:
		rset("velocity", velocity)
		calculate_direction()
	else:
		randomize_velocity() # If generated velocity is equal to zero

func calculate_direction():
	.calculate_direction()
	
	# Move interface
	match direction:
		UP, DOWN:
			$Name.rect_position.y = -50
			$HealthBar.rect_position.y = -36
		LEFT, RIGHT:
			$Name.rect_position.y = -26
			$HealthBar.rect_position.y = -12

func _on_VisibleArea_body_entered(body):
	if get_tree().is_network_server() and body.is_in_group("Players") and current_target == null:
		$RandomActionTimer.stop()
		current_target = body
		current_action = RUNNING
		rset("current_target", current_target)
		rset("current_action", current_action)

func _on_VisibleArea_body_exited(body):
	if get_tree().is_network_server() and body.is_in_group("Players") and current_target == body:
		
		# Search for a new target
		for new_body in $VisibleArea.get_overlapping_bodies():
			if new_body.is_in_group("Players") and new_body != current_target:
				current_target = new_body
				rset("current_target", current_target)
				return
		
		# If a target was not found
		make_random_action()
		current_target = null
		rset("current_target", current_target)
