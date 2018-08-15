extends Control

func _process(delta):
	# Change the player's vector depending on the keys
	if Input.is_action_pressed("ui_up") and $Character/Body/Animation.current_animation != "up":
		$Character/Body/Animation.play("up")
		$Character/Hair/Animation.play("up")
		$Character/Eyes/Animation.play("up")
	if Input.is_action_pressed("ui_left") and $Character/Body/Animation.current_animation != "left":
		$Character/Body/Animation.play("left")
		$Character/Hair/Animation.play("left")
		$Character/Eyes/Animation.play("left")
	if Input.is_action_pressed("ui_down") and $Character/Body/Animation.current_animation != "down":
		$Character/Body/Animation.play("down")
		$Character/Hair/Animation.play("down")
		$Character/Eyes/Animation.play("down")
	if Input.is_action_pressed("ui_right") and $Character/Body/Animation.current_animation != "right":
		$Character/Body/Animation.play("right")
		$Character/Hair/Animation.play("right")
		$Character/Eyes/Animation.play("right")

func _ready():
	$Character/Body/Animation.play("down")
	$Character/Hair/Animation.play("down")
	$Character/Eyes/Animation.play("down")
	$Character/HealthBar.visible = false
	$Panel/Controls/Hair/ColorPicker.color = Color(randf(), randf(), randf())

func _set_sex(Id):
	# Disable some hairs for male (Id = 0)
	for i in range(17, 30):
		$Panel/Controls/Hair/Type.set_item_disabled(i, !Id)
	
	# Check if character has wrong hair
	if Id == 0 and $Panel/Controls/Hair/Type.selected >= 17:
		$Panel/Controls/Hair/Type.selected = 16
		$Character.hair = $Panel/Controls/Hair/Type.get_item_text(16)
	
	$Character.sex = $Panel/Controls/Sex/Type.get_item_text(Id)
	$Character.load_sprite()

func _set_race(Id):
	$Character.race = $Panel/Controls/Race/Type.get_item_text(Id)
	$Character.load_sprite()

func _set_hair(Id):
	$Character.hair = $Panel/Controls/Hair/Type.get_item_text(Id)
	$Character.load_sprite()

func _set_eyes(Id):
	$Character.eyes = $Panel/Controls/Eyes/Type.get_item_text(Id)
	$Character.load_sprite()

func _set_skintone(Id):
	$Character.skintone = $Panel/Controls/Skintone/Type.get_item_text(Id)
	$Character.load_sprite()

func _on_Done_pressed():
	Global.player["nickname"] = $Panel/Controls/Nickname/Text.text
	Global.player["sex"] = $Panel/Controls/Sex/Type.text
	Global.player["race"] = $Panel/Controls/Race/Type.text
	Global.player["skintone"] = $Panel/Controls/Skintone/Type.text
	Global.player["hair"] = $Panel/Controls/Hair/Type.text
	Global.player["hair_color"] = $Panel/Controls/Hair/ColorPicker.color
	Global.player["eyes"] = $Panel/Controls/Eyes/Type.text
	get_tree().change_scene("res://Scenes/UI/JoinHost.tscn")

func _on_Color_color_changed(color):
	$Character/Hair.modulate = color
