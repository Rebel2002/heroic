extends Creature

func set_health(value) -> void:
	if not $Animation.is_playing():
		$Animation.play("Damaged")
	.set_health(value)