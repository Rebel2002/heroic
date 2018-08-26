extends "res://Scripts/Creatures/Creature.gd"

var currentTarget
enum {NONE, WALKING, HOWLING, RUNNING}

func _ready():
	make_random_action()
	
func _process(delta):
	if currentAction == WALKING:
		# Try to move in random direction
		if (move_and_collide(velocity * delta) != null):
			# Change direction if creature collides
			randomize_velocity()
		else:
			# If moving successful
			play_animation("Walk")
	elif currentAction == RUNNING:
		target_velocity()
		play_animation("Run")
		move_and_collide(velocity * delta)

func make_random_action():
	var action
	var time = OS.get_time().hour
	if time > 21 || time < 4:
		action = randi() % 3
	else:
		action = randi() % 2
	
	match action:
		NONE:
			stop_animation()
			$RandomActionTimer.wait_time = 1
		WALKING:
			randomize_velocity()
			$RandomActionTimer.wait_time = randi() % 5 + 2
		HOWLING:
			play_animation("Howl")
			$RandomActionTimer.wait_time = 1.8
	
	currentAction = action
	$RandomActionTimer.start()

# Generate random movement
func randomize_velocity():
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	velocity = velocity.normalized() * speed / 2
	if velocity.length() == 0:
		# If generated velocity is equal to zero
		randomize_velocity()
	else:
		calculate_direction()

# Calculate direction to current target
func target_velocity():
	velocity = to_local(currentTarget.position).normalized() * speed
	calculate_direction()

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

func stop_animation():
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

func _on_VisibleArea_body_entered(body):
	if body.is_in_group("Players"):
		$RandomActionTimer.stop()
		currentTarget = body
		currentAction = RUNNING

func _on_VisibleArea_body_exited(body):
	if body.is_in_group("Players"):
		make_random_action()
