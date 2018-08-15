extends Area2D

func _ready():
	pass

func _on_Transparency_body_entered(body):
	if body.is_in_group("Players") and body.is_network_master():
		get_owner().modulate = Color(1, 1, 1, 0.5)


func _on_Transparency_body_exited(body):
	if body.is_in_group("Players") and body.is_network_master():
		 get_owner().modulate = Color(1, 1, 1, 1)