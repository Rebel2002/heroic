extends Control

func _process(_delta: float) -> void:
	# Change the player's vector depending on the keys
	if Input.is_action_pressed("ui_up"):
		$Character.direction = $Character.UP
	elif Input.is_action_pressed("ui_left"):
		$Character.direction = $Character.LEFT
	elif Input.is_action_pressed("ui_down"):
		$Character.direction = $Character.DOWN
	elif Input.is_action_pressed("ui_right"):
		$Character.direction = $Character.RIGHT
	$Character.play_animation("Walk")

func _ready() -> void:
	$Character.play_animation("Walk")
	$Character/HealthBar.visible = false
	$Character/Name.visible = false
	
	$Panel/GridContainer/HairColor.color = Color(randf(), randf(), randf())
	$Panel/GridContainer/Skintone.color = Color(randf(), randf(), randf())
	$Panel/GridContainer/Eyes.color = Color(randf(), randf(), randf())

func _change_nickname(nickname: String) -> void:
	$Character.game_name = nickname
	$Done.disabled = nickname.empty()

func _change_sex(id: int) -> void:
	# Disable some hairs for male (id = 0)
	for i in range(17, 30):
		$Panel/GridContainer/Hair.set_item_disabled(i, !id)
	
	# Check if character has wrong hair
	if id == 0 and $Panel/GridContainer/Hair.selected >= 17:
		$Panel/GridContainer/Hair.selected = 16
		$Character.hair = $Panel/GridContainer/Hair.get_item_text(16)
	
	$Character.sex = $Panel/GridContainer/Sex.get_item_text(id)

func _change_race(id: int) -> void:
	$Character.race = $Panel/GridContainer/Race.get_item_text(id)

func _change_hair(id: int) -> void:
	$Character.hair = $Panel/GridContainer/Hair.get_item_text(id)

func _change_hair_color(color: Color) -> void:
	$Character.hair_color = color

func _change_eyes_color(color: Color) -> void:
	$Character.eyes = color

func _change_skintone_color(color: Color) -> void:
	$Character.skintone = color

func _on_Done_pressed() -> void:
	# Save properties
	Global.player = $Character.data()
	
	var _error = get_tree().change_scene("res://Scenes/UI/JoinHost.tscn")
