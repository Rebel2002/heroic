extends "res://Scripts/Creatures/Creature.gd"

var current_target
enum {NONE, WALKING, EATING}

func _ready():
	if get_tree().is_network_server():
		make_random_action()
	
func _process(delta):
	if get_tree().is_network_server():
		rpc_unreliable("set_position", position) # Send position to avoid desync
	
	match current_action:
		NONE:
			stop_animation()
		WALKING:
			# Try to move in random direction
			if move_and_collide(velocity * delta) != null:
				if get_tree().is_network_server():
					randomize_velocity() # Change direction if creature collides
			else:
				play_animation("Walk") # If moving successful
		EATING:
			play_animation("Eat")

# Add transformation baked chicken to deathdd
remote func set_health(value):
	if value > 0:
		.set_health(value)
	else:
		get_node("../../..").rpc("drop_item", "res://Scenes/Items/BackedChicken.tscn", 1, position)
		rpc("remove")

remote func synchronize_data(id):
	.synchronize_data(id)
	
	if current_target != null:
		rset_id(id, "current_target", current_target)

sync func stop_animation():
	$Body/Animation.stop()
	match direction:
		UP:
			$Body.set_frame(0)
		LEFT:
			$Body.set_frame(4)
		DOWN:
			$Body.set_frame(8)
		RIGHT:
			$Body.set_frame(12)

func make_random_action():
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
func randomize_velocity():
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	velocity = velocity.normalized() * speed / 2
	if velocity.length() != 0:
		rset("velocity", velocity)
		calculate_direction()
	else:
		randomize_velocity() # If generated velocity is equal to zero