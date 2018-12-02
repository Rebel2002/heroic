extends "res://Scripts/Creatures/Creature.gd"

func set_health(value):
	if not $Body/Animation.is_playing():
		$Body/Animation.play("Damaged")
	.set_health(value)
