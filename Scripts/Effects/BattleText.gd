extends Node2D

func damage(number):
	$Animation.play("Damage")
	$Label.text = str(number)

func _on_animation_finished(anim_name):
	self.queue_free()
