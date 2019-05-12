extends Node2D
class_name BattleText

func damage(number: int) -> void:
	$Animation.play("Damage")
	$Label.text = str(number)

func _on_animation_finished() -> void:
	self.queue_free()
