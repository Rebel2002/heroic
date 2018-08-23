extends "res://Scripts/Creatures/Creature.gd"

var currentAction
enum {NONE, WALKING, HOWLING}

func _ready():
	_on_ActionTimer_timeout()
	
func _process(delta):
	if currentAction == WALKING:
		if (move_and_collide(velocity * delta) != null):
			# If creature collides
			_randomize_velocity()
		else:
			# If moving successful
			_walk_animation()

# Wait some time before movement
func _on_ActionTimer_timeout():
	var action
	var time = OS.get_time().hour
	if time > 21 || time < 4:
		action = randi() % 3
	else:
		action = randi() % 2
	
	match action:
		NONE:
			_stop_animation()
			$ActionTimer.wait_time = 1
		WALKING:
			_randomize_velocity()
			$ActionTimer.wait_time = randi() % 5 + 2
		HOWLING:
			_howl_animation()
			$ActionTimer.wait_time = 1.8
	currentAction = action
	$ActionTimer.start()

func _randomize_velocity():
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	velocity = velocity.normalized() * speed / 2
	if velocity.length() == 0:
		# If generated velocity is equal to zero
		_randomize_velocity()

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
	if velocity.x == 0 and velocity.y < 0:
		if $Body/Animation.current_animation != "WalkUp":
			_set_direction(UP)
			$Body/Animation.play("WalkUp")
	elif velocity.x < 0:
		if $Body/Animation.current_animation != "WalkLeft":
			_set_direction(LEFT)
			$Body/Animation.play("WalkLeft")
	elif velocity.x == 0 and velocity.y > 0:
		if $Body/Animation.current_animation != "WalkDown":
			_set_direction(DOWN)
			$Body/Animation.play("WalkDown")
	elif velocity.x > 0:
		if $Body/Animation.current_animation != "WalkRight":
			_set_direction(RIGHT)
			$Body/Animation.play("WalkRight")

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
			
func _set_direction(value):
	direction = value
	
	# Rotate collision
	match direction:
		UP, DOWN:
			$Collision.position.y = 0
			$Collision.rotation = 0
		LEFT, RIGHT:
			$Collision.position.y = 25
			$Collision.rotation = 90