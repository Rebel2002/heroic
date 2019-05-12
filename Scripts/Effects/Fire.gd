extends Area2D

func _ready() -> void:
	$Sprite/Animation.play("fire")

func _on_Fire_body_entered(_animation_name) -> void:
	# Damage to bodies when timer ends
	if get_tree().is_network_server():
		$DamageTimer.start()
	
func _on_Fire_body_exited(_animation_name) -> void:
	if get_overlapping_bodies().empty():
		$DamageTimer.stop()

func _on_DamageTimer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Players") and body.health > 0:
			body.rset("health", body.health - Global.random(Vector2(1, 4)))