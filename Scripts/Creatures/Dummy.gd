extends Creature

func set_health(value) -> void:
	if not $Body/Animation.is_playing():
		$Body/Animation.play("Damaged")
	.set_health(value)
