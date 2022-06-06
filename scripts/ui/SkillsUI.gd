class_name SkillsUI extends Control

signal ability_on_cooldown(ability_name)

func _ready():
	connect("ability_on_cooldown", get_parent().get_parent().get_node("Player"), "ability_on_entering_cooldown")
	$PrimarySkill/FireSaw/Label.text = ""

func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			toggle_firesaw()
func toggle_firesaw():
	print("firesaw toggled")
	# 8 seconds is the duration of the firesaw before expiring
	yield(get_tree().create_timer(8), "timeout")
	emit_signal("ability_on_cooldown", "FireSaw")
	$PrimarySkill/FireSaw/FiresawTimer.start()

func _physics_process(delta):
	if !$PrimarySkill/FireSaw/FiresawTimer.is_stopped():
		$PrimarySkill/FireSaw/Sprite.self_modulate.a = 0.75
		$PrimarySkill/FireSaw/Label.text = str(round($PrimarySkill/FireSaw/FiresawTimer.time_left))
	elif $PrimarySkill/FireSaw/FiresawTimer.is_stopped():
		$PrimarySkill/FireSaw/Sprite.self_modulate.a = 1.0
		$PrimarySkill/FireSaw/Label.text = ""
