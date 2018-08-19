extends "res://Scripts/Creatures/Creature.gd"

func _ready():
	_randomize_velocity()
	
func _process(delta):
	if (move_and_collide(velocity * delta) != null || velocity.length() == 0):
		# If creature collides
		_randomize_velocity()
	else:
		# Animate movement
		if velocity.x == 0 and velocity.y < 0:
			if $Body/Animation.current_animation != "WalkUp":
				$Body/Animation.play("WalkUp")
		elif velocity.x < 0:
			if $Body/Animation.current_animation != "WalkLeft":
				$Body/Animation.play("WalkLeft")
		elif velocity.x == 0 and velocity.y > 0:
			if $Body/Animation.current_animation != "WalkDown":
				$Body/Animation.play("WalkDown")
		elif velocity.x > 0:
			if $Body/Animation.current_animation != "WalkRight":
				$Body/Animation.play("WalkRight")
		else:
			match $Body/Animation.current_animation:
				"up":
					$Body.set_frame(5)
				"left":
					$Body.set_frame(15)
				"down":
					$Body.set_frame(0)
				"right":
					$Body.set_frame(10)
				_:
					$Body/Animation.stop()

func _randomize_velocity():
	$RandomTimer.wait_time = randi() % 9 + 1
	$RandomTimer.start()
	velocity = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	velocity = velocity.normalized() * speed / 2
	