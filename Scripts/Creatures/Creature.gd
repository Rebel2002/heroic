extends KinematicBody2D

export var game_name = "" setget _set_game_name
export (int) var speed  = 200 # How fast the player will move (pixels/sec).
export (int) var health = 8 setget _set_health
sync var velocity = Vector2()
var currentAction
var can_move = true

sync var direction = DOWN
enum {UP, DOWN, LEFT, RIGHT}

func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health

func _set_game_name(string):
	game_name = string
	if has_node("Name"):
		$Name.text = string

func _set_health(value):
	health = value
	
	if (has_node("HealthBar")):
		$HealthBar.visible = true
		$HealthBar.value = value
	
	if (has_node("HealthBar/DisplayTimer")):
		$HealthBar/DisplayTimer.start()
	
	if health <= 0:
		can_move = false
		$Body/Animation.play("Death")

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

func play_animation(animation):
	animation += direction_string() # Add animation direction
	if $Body/Animation.current_animation != animation:
		$Body/Animation.play(animation)

func _on_SpeechDisplayTimer_timeout():
	$Speech.visible = false

func _on_DisplayTimer_timeout():
	$HealthBar.visible = false
