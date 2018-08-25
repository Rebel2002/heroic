extends "res://Scripts/Creatures/Creature.gd"

var currentTarget
var currentAction
enum {NONE, WALKING, HOWLING, RUNNING}

func _ready():
	_random_action()
	
func _process(delta):
	calculate_direction()
	if currentAction == WALKING:
		if (move_and_collide(velocity * delta) != null):
			# If creature collides
			_randomize_velocity()
		else:
			# If moving successful
			_walk_animation()
	elif currentAction == RUNNING:
		_calculate_velocity()
		move_and_collide(velocity * delta)
		_run_animation()

# Wait some time before movement
func _random_action():
	var action
	var time = OS.get_time().hour
	if time > 21 || time < 4:
		action = randi() % 3
	else:
		action = randi() % 2
	
	match action:
		NONE:
			_stop_animation()
			$RandomActionTimer.wait_time = 1
		WALKING:
			_randomize_velocity()
			$RandomActionTimer.wait_time = randi() % 5 + 2
		HOWLING:
			_howl_animation()
			$RandomActionTimer.wait_time = 1.8
	
	currentAction = action
	$RandomActionTimer.start()

# Set random movement
func _randomize_velocity():
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	velocity = velocity.normalized() * speed / 2
	if velocity.length() == 0:
		# If generated velocity is equal to zero
		_randomize_velocity()

func _calculate_velocity():
	velocity = to_local(currentTarget.position).normalized() * speed

	# Rotate collision
	match direction:
		UP, DOWN:
			$Name.rect_position.y = -50
			$HealthBar.rect_position.y = -36
		LEFT, RIGHT:
			$Name.rect_position.y = -26
			$HealthBar.rect_position.y = -12

func _stop_animation():
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

func _walk_animation():
	match direction:
		UP:
			if $Body/Animation.current_animation != "WalkUp":
				$Body/Animation.play("WalkUp")
		LEFT:
			if $Body/Animation.current_animation != "WalkLeft":
				$Body/Animation.play("WalkLeft")
		DOWN:
			if $Body/Animation.current_animation != "WalkDown":
				$Body/Animation.play("WalkDown")
		RIGHT:
			if $Body/Animation.current_animation != "WalkRight":
				$Body/Animation.play("WalkRight")

func _run_animation():
	match direction:
		UP:
			if $Body/Animation.current_animation != "RunUp":
				$Body/Animation.play("RunUp")
		LEFT:
			if $Body/Animation.current_animation != "RunLeft":
				$Body/Animation.play("RunLeft")
		DOWN:
			if $Body/Animation.current_animation != "RunDown":
				$Body/Animation.play("RunDown")
		RIGHT:
			if $Body/Animation.current_animation != "RunRight":
				$Body/Animation.play("RunRight")

func _howl_animation():
	$Sound.play()
	match direction:
		UP:
			$Body/Animation.play("HowlUp")
		LEFT:
			$Body/Animation.play("HowlLeft")
		DOWN:
			$Body/Animation.play("HowlDown")
		RIGHT:
			$Body/Animation.play("HowlRight")

func _on_VisibleArea_body_entered(body):
	if body.is_in_group("Players"):
		$RandomActionTimer.stop()
		currentTarget = body
		currentAction = RUNNING


func _on_VisibleArea_body_exited(body):
	if body.is_in_group("Players"):
		_random_action()
