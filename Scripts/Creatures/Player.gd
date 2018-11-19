extends "res://Scripts/Creatures/Humanoid.gd"

enum {NONE, WALKING, ATTACKING}

func _ready():
	if is_network_master():
		$Camera.make_current()

func _process(delta):
	if can_move:
		# Read pressed keys
		if (is_network_master()):
			current_action = NONE
			if (Input.is_action_just_pressed("ui_attack")
			or $Body/Animation.current_animation == "MeleeAttack" + direction_string()):
				current_action = ATTACKING
			
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
				current_action = WALKING
				velocity = velocity.normalized() * speed
			
			calculate_direction()
			
			rset("current_action", current_action)
			rset("velocity", velocity)
			rpc_unreliable("set_position", position) # Send position to avoid desync
		
		# Make actions
		match current_action:
			WALKING:
				play_animation("Walk")
				move_and_collide(velocity * delta)
			ATTACKING:
				play_animation("MeleeAttack")
			NONE:
				stop_animation()