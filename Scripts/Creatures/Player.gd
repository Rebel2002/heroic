extends "res://Scripts/Creatures/Humanoid.gd"

enum {NONE, WALKING, ATTACKING}

func _ready():
	if is_network_master():
		$Camera.make_current()

func _process(delta):
	if can_move:
		calculate_direction()
		
		# Read pressed keys
		if (is_network_master()):
			currentAction = NONE
			if (Input.is_action_just_pressed("ui_attack") 
			or $Body/Animation.current_animation == "MeleeAttack" + direction_string()):
				currentAction = ATTACKING
			
			# Change the player's vector depending on the keys
			velocity = Vector2()
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
				currentAction = WALKING
				velocity = velocity.normalized() * speed
			
			rset("velocity", velocity)
		
		# Make actions
		match currentAction:
			WALKING:
				play_animation("Walk")
				move_and_collide(velocity * delta)
				if (is_network_master()):
					rpc("set_position", position)
			ATTACKING:
				play_animation("MeleeAttack")
			NONE:
				stop_animation()

remote func set_position(newPosition):
	position = newPosition