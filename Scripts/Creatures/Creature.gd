extends KinematicBody2D
class_name Creature

var BattleText: Resource = preload("res://Scenes/Effects/BattleText.tscn")

# Stats
export(String) var game_name = "" setget set_game_name
export(Vector2) var damage = Vector2(1, 1)
var speed  = 200 # How fast creature will move (pixels/sec).
var strength = 15
var can_move = true

sync var health: int = 6 setget set_health
remote var velocity: Vector2 setget set_velocity
remote var current_action: int
remote var direction: int = DOWN
enum {UP, DOWN, LEFT, RIGHT}

func _ready() -> void:
	# Set health bar values
	$HealthBar.max_value = health
	$HealthBar.value = health
	
	# Request data from the server
	if get_tree().has_network_peer() and not is_network_master() and not get_tree().is_network_server():
		rpc_id(1, "synchronize_data", get_tree().get_network_unique_id())

func set_game_name(name: String) -> void:
	game_name = name
	$Name.text = name

func set_health(value: int) -> void:
	# Show damage
	var battle_text = BattleText.instance()
	battle_text.damage(value - health)
	add_child(battle_text)
	
	health = value
	$HealthBar.visible = true
	$HealthBar.value = value
	$HealthBar/DisplayTimer.start()
	
	if health <= 0:
		can_move = false
		$Animation.play("Death")

func set_velocity(value) -> void:
	velocity = value
	calculate_direction()

remote func synchronize_data(id: int) -> void:
	# Send values if if they are not default
	if position != Vector2():
		rpc_unreliable_id(id, "set_position", position)
	if direction != DOWN:
		rset_id(id, "direction", direction)
	if current_action != 0:
		rset_id(id, "current_action", current_action)

remote func set_position(pos: Vector2) -> void:
	position = pos

sync func remove() -> void:
	queue_free()

func say(text: String) -> void:
	$Speech/RichTextLabel.bbcode_text = "[center]" + text + "[/center]"
	
	# Vertical size
	var lines: float = ceil(float(text.length()) / 17)
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

func calculate_direction() -> void:
	if velocity.x < 0.3 * speed and velocity.x > -0.3 * speed and velocity.y < 0:
		direction = UP
	elif velocity.x < -0.3 * speed:
		direction = LEFT
	elif velocity.x < 0.3 * speed and velocity.x > -0.3 * speed and velocity.y > 0:
		direction = DOWN
	elif velocity.x > 0.3 * speed:
		direction = RIGHT

func _on_animation_finished(animation: String) -> void:
	if not get_tree().is_network_server() or not animation.begins_with("MeleeAttack"):
		return
	
	# Reset animation state
	$Animation.play_directional_animation("Walk")
	$Animation.stop()
	
	# Detect objects in damage area and make damage
	for body in $InterractArea.get_overlapping_bodies():
		if body == self or not body.is_in_group("Creature") or body.health <= 0:
			continue

		# Check the position for damage only by facing the target.
		if (direction == UP and body.position.y < self.position.y
				or direction == DOWN and body.position.y > self.position.y
				or direction == LEFT and body.position.x < self.position.x
				or direction == RIGHT and body.position.x > self.position.x):
			body.rset("health", body.health - Global.random(damage) - Global.modifier(strength))