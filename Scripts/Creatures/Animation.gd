extends AnimationPlayer

# Reimplement to reset animation sprite on stop
sync func stop(reset: bool = true) -> void:
	if is_playing():
		seek(0, true)
		.stop(reset)

sync func play_directional_animation(animation: String) -> void:
	animation += direction_string() # Add animation direction
	if current_animation != animation:
		play(animation)

func direction_string() -> String:
	match get_node(root_node).direction:
		Creature.UP:
			return "Up"
		Creature.LEFT:
			return "Left"
		Creature.DOWN:
			return "Down"
		Creature.RIGHT:
			return "Right"