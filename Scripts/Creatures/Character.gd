extends KinematicBody2D

export var game_name = "" setget _set_game_name
export(String, "Male", "Female") var sex = "Male"
export(String, "Human", "Elf", "Orc", "Skeleton") var race = "Human"
export(String) var hair = "Pixie"
export(Color) var hair_color = Color(1, 1, 1)
export(String, "Blue", "Brown", "Gray", "Green", "Orange", "Purple", "Red", "Yellow") var eyes = "Blue"
export (int, 1, 2, 3) var skintone = 1
export (int) var speed  = 200 # How fast the player will move (pixels/sec).
export (int) var health = 8 setget _set_health
var can_move = true

func _ready():
	load_sprite()
	$HealthBar.max_value = health
	$HealthBar.value = health

func _process(delta):
	pass

func load_sprite():
	$Body.texture = load("res://Sprites/Creatures/Character/" +
						sex +
						"/Races/" +
						race +
						"/" +
						str(skintone) +
						".png")
	if race != "Orc":
		$Eyes.texture = load("res://Sprites/Creatures/Character/" +
						sex +
						"/Eyes/" +
						eyes +
						".png")
		$Hair.texture = load("res://Sprites/Creatures/Character/" +
						sex +
						"/Hairs/" +
						hair +
						".png")
		$Hair.modulate = hair_color

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
		$Hair/Animation.play("death")
		$Eyes/Animation.play("death")

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