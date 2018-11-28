extends "res://Scripts/Creatures/Creature.gd"

# Visual properties
export(String, "Male", "Female") var sex = "Male"
export(String, "Human", "Elf", "Orc", "Skeleton") var race = "Human"
export(String) var hair = "Pixie"
export(Color) var hair_color = Color(1, 1, 1)
export(String, "Blue", "Brown", "Gray", "Green", "Orange", "Purple", "Red", "Yellow") var eyes = "Blue"
export (int, 1, 3) var skintone = 1

# Equipment
sync var weapon setget set_weapon

func _ready():
	load_sprite()

# Override the parent function to add body parts animations
func set_health(value):
	.set_health(value)

	if health <= 0:
		$Hair/Animation.play("Death")
		$Eyes/Animation.play("Death")

func set_weapon(weapon_name):
	if weapon_name != null:
		weapon = load("res://Scenes/Items/" + weapon_name + ".tscn")
		$Weapon.texture = load("res://Sprites/Items/" + weapon_name + "Animation.png")
	else:
		weapon = null
		$Weapon.texture = null

func load_sprite():
	$Body.texture = load("res://Sprites/Creatures/Character/" +
						sex +
						"/Races/" +
						race +
						"/" +
						str(skintone) +
						".png")
						
	# Orcs do not have hair and eye sprites
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
	else:
		$Eyes.texture = null
		$Hair.texture = null

# Override the parent function to add body parts animations
func play_animation(animation):
	animation += direction_string() # Add animation direction
	if $Body/Animation.current_animation != animation:
		$Body/Animation.play(animation)
		$Hair/Animation.play(animation)
		$Eyes/Animation.play(animation)
		if $Weapon/Animation.has_animation(animation):
			$Weapon/Animation.play(animation)

func stop_animation():
	match direction:
		UP:
			$Body.set_frame(104)
			$Hair.set_frame(104)
			$Eyes.set_frame(104)
		LEFT:
			$Body.set_frame(117)
			$Hair.set_frame(117)
			$Eyes.set_frame(117)
		DOWN:
			$Body.set_frame(130)
			$Hair.set_frame(130)
			$Eyes.set_frame(130)
		RIGHT:
			$Body.set_frame(143)
			$Hair.set_frame(143)
			$Eyes.set_frame(143)