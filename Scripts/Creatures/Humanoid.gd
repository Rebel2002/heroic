extends Creature
class_name Humanoid

# Visual properties
export(String, "Male", "Female") var sex = "Male" setget set_sex
export(String, "Human", "Elf", "Orc") var race = "Human" setget set_race
export(String) var hair = "Pixie" setget set_hair
export(Color) var hair_color = Color(1, 1, 1) setget set_hair_color
export(Color) var skintone = Color(1, 1, 1) setget set_skintone
export(Color) var eyes = Color(1, 1, 1) setget set_eyes

# Equipment
# warning-ignore:unused_class_variable
var weapon

# Override the parent function to add body parts animations
func set_health(value) -> void:
	.set_health(value)

	if health <= 0:
		$Hair/Animation.play("Death")
		$Eyes/Animation.play("Death")

# Override the parent function to add body parts animations
func play_animation(animation) -> void:
	animation += direction_string() # Add animation direction
	if $Body/Animation.current_animation != animation:
		$Body/Animation.play(animation)
		$Hair/Animation.play(animation)
		$Eyes/Animation.play(animation)
		if $Weapon/Animation.has_animation(animation):
			$Weapon/Animation.play(animation)
		else:
			$Weapon.visible = false

func stop_animation() -> void:
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

func set_data(data: Dictionary) -> void:
	self.game_name = data["game_name"]
	self.sex = data["sex"]
	self.race = data["race"]
	self.hair = data["hair"]
	self.hair_color = data["hair_color"]
	self.skintone = data["skintone"]
	self.eyes = data["eyes"]

func data() -> Dictionary:
	var data = Dictionary()
	data["game_name"] = game_name
	data["sex"] = sex
	data["race"] = race
	data["hair"] = hair
	data["hair_color"] = hair_color
	data["skintone"] = skintone
	data["eyes"] = eyes
	
	return data

func set_sex(name: String) -> void:
	sex = name
	$Body.texture = load("res://Sprites/Creatures/Character/"
			+ sex
			+ "/Races/"
			+ race
			+ ".png")
	$Body.modulate = skintone

func set_race(name: String) -> void:
	race = name
	$Body.texture = load("res://Sprites/Creatures/Character/"
			+ sex
			+ "/Races/"
			+ race
			+ ".png")
	$Body.modulate = skintone
	if race == "Orc":
		self.hair = ""

func set_hair(name: String) -> void:
	# Orcs do not have hair
	if race == "Orc":
		$Hair.texture = null
		return
	
	hair = name
	$Hair.texture = load("res://Sprites/Creatures/Character/"
			+ sex
			+ "/Hairs/"
			+ hair
			+ ".png")
	$Hair.modulate = hair_color

func set_hair_color(color: Color) -> void:
	hair_color = color
	$Hair.modulate = hair_color

func set_skintone(color: Color) -> void:
	skintone = color
	$Body.modulate = skintone

func set_eyes(color: Color) -> void:
	# Orcs do not have eye sprites
	eyes = color
	$Eyes.modulate = eyes

sync func equip_weapon(weapon_name) -> void:
	if weapon_name != null:
		var weapon = load("res://Scenes/Items/" + weapon_name + ".tscn").instance()
		$Weapon.texture = load("res://Sprites/Items/" + weapon_name + "Animation.png")
		damage = weapon.damage
	else:
		damage = Vector2(1, 1)
		$Weapon.texture = null