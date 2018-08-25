extends "res://Scripts/Creatures/Humanoid.gd"

func _ready():
	if is_network_master():
		$Camera.make_current()

func _process(delta):
	if can_move:
		if (is_network_master()):
			velocity = Vector2()
			
			# Change the player's vector depending on the keys
			if Input.is_action_pressed("ui_up"):
				velocity.y -= 1
			if Input.is_action_pressed("ui_left"):
			 	velocity.x -= 1
			if Input.is_action_pressed("ui_down"):
			 	velocity.y += 1
			if Input.is_action_pressed("ui_right"):
				velocity.x += 1
		
			# Normalize vector
			if velocity.length() > 0:
	        	velocity = velocity.normalized() * speed
			
			rset("velocity", velocity)
		
		move_and_collide(velocity * delta)
		if (is_network_master()):
			rpc("set_position", position)
		
		# Animate movement
		if velocity.length() != 0:
			calculate_direction()
			match direction:
				UP:
					play_animation("WalkUp")
				LEFT:
					play_animation("WalkLeft")
				RIGHT:
					play_animation("WalkRight")
				DOWN:
					play_animation("WalkDown")
		else:
			stop_animation()

remote func set_position(newPosition):
	position = newPosition