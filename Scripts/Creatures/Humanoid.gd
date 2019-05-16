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