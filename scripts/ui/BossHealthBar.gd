class_name BossHealthBar extends Control

var weakness_count : int = 0

func _ready():
	pass

func set_max_health_bar_value(max_value):
	$HealthBar.max_value = max_value

func set_health_bar_value(value):
	$HealthBar.value = value

func set_boss_name(new_name : String, level : int):
	var text : String = "[center][color=#ffd703]%s[/color] (Lv.%2.0f)" % [new_name, level]
	$BossNameLabel.bbcode_text = text

func add_weakness_display(weakness_type : String):
	var new_wd_sprite = Sprite.new()
	new_wd_sprite.scale = Vector2(1.5, 1.5)
	new_wd_sprite.position.x = $WeaknessDisplayPosition.position.x + (28 * weakness_count)
	new_wd_sprite.position.y = $WeaknessDisplayPosition.position.y
	match weakness_type:
		"Physical":
			new_wd_sprite.texture = load("res://assets/UI/physical_type_icon.png")
		"Fire":
			new_wd_sprite.texture = load("res://assets/UI/fire_type_icon.png")
		"Ice":
			new_wd_sprite.texture = load("res://assets/UI/physical_type_icon.png")
		"Earth":
			new_wd_sprite.texture = load("res://assets/UI/earth_type_icon.png")
		"Lightning":
			new_wd_sprite.texture = load("res://assets/UI/lightning_type_icon.png")
	weakness_count += 1
	add_child(new_wd_sprite)
	
