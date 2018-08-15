extends "res://Scripts/Creatures/Creature.gd"

export(String, "Male", "Female") var sex = "Male"
export(String, "Human", "Elf", "Orc", "Skeleton") var race = "Human"
export(String) var hair = "Pixie"
export(Color) var hair_color = Color(1, 1, 1)
export(String, "Blue", "Brown", "Gray", "Green", "Orange", "Purple", "Red", "Yellow") var eyes = "Blue"
export (int, 1, 3) var skintone = 1

func _ready():
	load_sprite()
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

# Override the parent function to add body parts animations
func _set_health(value):
	health = value
	
	if (has_node("HealthBar")):
		$HealthBar.value = value
	
	if health <= 0:
		can_move = false
		$Body/Animation.play("death")
		$Hair/Animation.play("death")
		$Eyes/Animation.play("death")