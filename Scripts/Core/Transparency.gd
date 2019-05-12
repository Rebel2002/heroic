extends Area2D

func _on_Transparency_body_entered(body: PhysicsBody2D):
	if body.is_in_group("Players") and body.is_network_master():
		get_owner().modulate = Color(1, 1, 1, 0.5)


func _on_Transparency_body_exited(body: PhysicsBody2D):
	if body.is_in_group("Players") and body.is_network_master():
		 get_owner().modulate = Color(1, 1, 1, 1)