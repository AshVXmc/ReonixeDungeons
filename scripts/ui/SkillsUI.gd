class_name SkillsUI extends Control

signal ability_on_cooldown(ability_name)

func _ready():
	connect("ability_on_cooldown", get_parent().get_parent().get_node("Player"), "ability_on_entering_cooldown")
	$PrimarySkill/FireSaw/Label.text = ""
	
#	match Global.primary_skill:
#	match Global.secondary_skill:


func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			toggle_firesaw()
		"FireFairy":
			toggle_fire_fairy()
func toggle_firesaw():
	print("firesaw toggled")
	# 8 seconds is the duration of the firesaw before expiring
	yield(get_tree().create_timer(8), "timeout")
	emit_signal("ability_on_cooldown", "FireSaw")
	$PrimarySkill/FireSaw/FiresawTimer.start()

func toggle_fire_fairy():
	# 10 seconds is the duration of the fire fairy before expiring
	yield(get_tree().create_timer(10), "timeout")
	emit_signal("ability_on_cooldown", "FireFairy")
	$SecondarySkill/FireFairy/FirefairyTimer.start()
	
func _physics_process(delta):
	if !$PrimarySkill/FireSaw/FiresawTimer.is_stopped() and Global.mana < 3:
		$PrimarySkill/FireSaw/Sprite.self_modulate.a = 0.65
		$PrimarySkill/FireSaw/Label.text = str(round($PrimarySkill/FireSaw/FiresawTimer.time_left))
	elif $PrimarySkill/FireSaw/FiresawTimer.is_stopped():
		if Global.mana >= 3:
			$PrimarySkill/FireSaw/Sprite.self_modulate.a = 1.0
		else:
			$PrimarySkill/FireSaw/Sprite.self_modulate.a = 0.65
		$PrimarySkill/FireSaw/Label.text = ""
	
	if !$SecondarySkill/FireFairy/FirefairyTimer.is_stopped() and Global.mana < 3:
		$SecondarySkill/FireFairy/Sprite.self_modulate.a = 0.65
		$SecondarySkill/FireFairy/Label.text = str(round($SecondarySkill/FireFairy/FirefairyTimer.time_left))
	elif $SecondarySkill/FireFairy/FirefairyTimer.is_stopped():
		if Global.mana >= 3:
			$SecondarySkill/FireFairy/Sprite.self_modulate.a = 1.0
		else:
			$SecondarySkill/FireFairy/Sprite.self_modulate.a = 0.65
		$SecondarySkill/FireFairy/Label.text = ""


