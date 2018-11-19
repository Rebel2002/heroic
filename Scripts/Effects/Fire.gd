extends Area2D

var character

func _ready():
	$Sprite/Animation.play("fire")

func _on_Fire_body_entered(body):
	# Damage to bodies when timer ends
	if get_tree().is_network_server():
		$DamageTimer.start()
	
func _on_Fire_body_exited(body):
	if get_overlapping_bodies().empty():
		$DamageTimer.stop()

func _on_DamageTimer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("Players") and body.health > 0:
			body.health -= Global.dice(4)
			body.rset("health", body.health)