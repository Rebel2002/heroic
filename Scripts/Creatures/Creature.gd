extends KinematicBody2D

var BattleText = preload("res://Scenes/Effects/BattleText.tscn")

# Stats
export(String) var game_name = "" setget set_game_name
export(Vector2) var damage = Vector2(1, 1)
var speed  = 200 # How fast creature will move (pixels/sec).
var strength = 15
var can_move = true

sync var health = 200 setget set_health
remote var velocity = Vector2() setget set_velocity
remote var current_action = 0
remote var direction = DOWN
enum {UP, DOWN, LEFT, RIGHT}

func _ready():
	# Set health bar values
	$HealthBar.max_value = health
	$HealthBar.value = health
	
	# Request data from the server
	if get_tree().has_network_peer() and not is_network_master() and not get_tree().is_network_server():
		rpc_id(1, "synchronize_data", get_tree().get_network_unique_id())

func set_game_name(string):
	game_name = string
	if has_node("Name"):
		$Name.text = string

func set_health(value):
	# Show damage
	var battle_text = BattleText.instance()
	battle_text.damage(value - health)
	add_child(battle_text)
	
	health = value
	
	if (has_node("HealthBar")):
		$HealthBar.visible = true
		$HealthBar.value = value
		$HealthBar/DisplayTimer.start()
	
	if health <= 0:
		can_move = false
		$Body/Animation.play("Death")

func set_velocity(value):
	velocity = value
	calculate_direction()

func _on_Speech_DisplayTimer_timeout():
	$Speech.visible = false

func _on_HealthBar_DisplayTimer_timeout():
	$HealthBar.visible = false

remote func synchronize_data(id):
	# Send values if if they are not default
	if position != Vector2():
		rpc_unreliable_id(id, "set_position", position)
	if direction != DOWN:
		rset_id(id, "direction", direction)
	if current_action != 0:
		rset_id(id, "current_action", current_action)

remote func set_position(value):
	position = value

func say(text):
	$Speech/RichTextLabel.bbcode_text = "[center]" + text + "[/center]"
	
	# Vertical size
	var lines = ceil(float(text.length()) / 17)
	$Speech/RichTextLabel.rect_size.y = 6 + 14 * lines
	$Speech/RichTextLabel.rect_position.y = 8 - 14 * (lines - 1)
	
	# Horizontal size
	if (text.length() <= 4):
		$Speech/RichTextLabel.rect_size.x = 42
	elif (text.length() <= 17):
		$Speech/RichTextLabel.rect_size.x = 6 + text.length() * 6.5
	else:
		$Speech/RichTextLabel.rect_size.x = 100
	
	$Speech.visible = true
	
	# Wait and hide dialog
	$Speech/DisplayTimer.start()

func calculate_direction():
	if velocity.x < 0.3 * speed and velocity.x > -0.3 * speed and velocity.y < 0:
		direction = UP
	elif velocity.x < -0.3 * speed:
		direction = LEFT
	elif velocity.x < 0.3 * speed and velocity.x > -0.3 * speed and velocity.y > 0:
		direction = DOWN
	elif velocity.x > 0.3 * speed:
		direction = RIGHT

func direction_string():
	match direction:
		UP:
			return "Up"
		LEFT:
			return "Left"
		DOWN:
			return "Down"
		RIGHT:
			return "Right"

sync func play_animation(animation):
	animation += direction_string() # Add animation direction
	if $Body/Animation.current_animation != animation:
		$Body/Animation.play(animation)

func _on_animation_finished(anim_name):
	if get_tree().is_network_server() and anim_name.begins_with("MeleeAttack"):
		# Detect objects in damage area and make damage
		for body in $InterractArea.get_overlapping_bodies():
			if body.is_in_group("Creature") and body.health > 0 and body != self:
				# Check the position for damage only by facing the target.
				if (direction == UP and body.position.y < self.position.y
				or direction == DOWN and body.position.y > self.position.y
				or direction == LEFT and body.position.x < self.position.x
				or direction == RIGHT and body.position.x > self.position.x):
					body.rset("health", body.health - Global.random(damage) - Global.modifier(strength))