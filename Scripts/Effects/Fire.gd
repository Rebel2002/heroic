extends Area2D

var character

func _ready():
	$Sprite/Animation.play("fire")

func _on_Fire_body_entered(body):
	$DamageTimer.start()
	
func _on_Fire_body_exited(body):
	if get_overlapping_bodies().empty():
		$DamageTimer.stop()

func _on_DamageTimer_timeout():
	if get_tree().is_network_server():
		for body in get_overlapping_bodies():
			if body.is_in_group("Players") and body.health > 0:
				body.rset("health", body.health - (randi() % 3 + 1))
				print(body.health)