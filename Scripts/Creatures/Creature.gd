extends KinematicBody2D

export var game_name = "" setget _set_game_name
export (int) var speed  = 200 # How fast the player will move (pixels/sec).
export (int) var health = 8 setget _set_health
var can_move = true

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
		$HealthBar.value = value
	
	if health <= 0:
		can_move = false
		$Body/Animation.play("death")

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

func _on_SpeechDisplayTimer_timeout():
	$Speech.visible = false