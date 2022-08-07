class_name SkillsUI extends Control

signal ability_on_cooldown(ability_name)
var firesawcost : int = 6
var firefairycost : int = 4
var fireballcost : int = 2
const playericon = preload("res://assets/UI/player_character_icon.png")
onready var character1 : String = Global.equipped_characters[0]

func _ready():
	Global.current_character = character1
	print("Currently: " + Global.current_character)
	connect("ability_on_cooldown", get_parent().get_parent().get_node("Player"), "ability_on_entering_cooldown")
	update_skill_ui(Global.player_skills["PrimarySkill"], Global.player_skills["SecondarySkill"])
	
	for c in Global.equipped_characters:
		match c:
			"Player":
				print("set as player")
				$Characters/Character1.texture = playericon
	


func update_skill_ui(primary : String, secondary : String):
	match primary:
		"FireSaw":
			$PrimarySkill/Player/FireSaw.visible = true
	match secondary:
		"FireFairy":
			$SecondarySkill/Player/FireFairy.visible = true
func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			toggle_firesaw()
		"FireFairy":
			toggle_fire_fairy()
func toggle_firesaw():
	print("firesaw toggled")
	# 8 seconds is the duration of the firesaw before expiring
	yield(get_tree().create_timer(6), "timeout")
	print("firesaw cooldown start")
	emit_signal("ability_on_cooldown", "FireSaw")
	$PrimarySkill/Player/FireSaw/FiresawTimer.start()

func toggle_fire_fairy():
	# 10 seconds is the duration of the fire fairy before expiring
	yield(get_tree().create_timer(10), "timeout")
	emit_signal("ability_on_cooldown", "FireFairy")
	$SecondarySkill/Player/FireFairy/FirefairyTimer.start()
	
func _process(delta):
	if !$PrimarySkill/Player/FireSaw/FiresawTimer.is_stopped():
		$PrimarySkill/Player/FireSaw/Label.text = str(round($PrimarySkill/Player/FireSaw/FiresawTimer.time_left))
	elif $PrimarySkill/Player/FireSaw/FiresawTimer.is_stopped():
		if Global.mana >= firesawcost:
			$PrimarySkill/Player/FireSaw/Sprite.self_modulate.a = 1.0
		else:
			$PrimarySkill/Player/FireSaw/Sprite.self_modulate.a = 0.65
		$PrimarySkill/Player/FireSaw/Label.text = ""
	if Global.mana < firesawcost:
		$PrimarySkill/Player/FireSaw/Sprite.self_modulate.a = 0.65
	
	if !$SecondarySkill/Player/FireFairy/FirefairyTimer.is_stopped():
		
		$SecondarySkill/Player/FireFairy/Label.text = str(round($SecondarySkill/Player/FireFairy/FirefairyTimer.time_left))
	elif $SecondarySkill/Player/FireFairy/FirefairyTimer.is_stopped():
		if Global.mana >= firefairycost:
			$SecondarySkill/Player/FireFairy/Sprite.self_modulate.a = 1.0
		else:
			$SecondarySkill/Player/FireFairy/Sprite.self_modulate.a = 0.65
		$SecondarySkill/Player/FireFairy/Label.text = ""
	if Global.mana < firefairycost:
		$SecondarySkill/Player/FireFairy/Sprite.self_modulate.a = 0.65




