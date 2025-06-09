class_name SulphuricSigil extends Node2D


onready var FIRE_DETIONATION_PARTICLE = preload("res://scenes/particles/FireDetonationParticle.tscn")
signal add_meter_to_firefairy(amount)
onready var fire_fairy = get_parent().get_parent().get_node("FireFairy")
# Perform two slashes in an X-shaped pattern like ayato's C6 effect. Has a small CD
onready var PLAYER = get_parent().get_parent().get_node("Player")

func set_attack_power():
	if Global.equipped_characters.has("Player"):
		if weakref(PLAYER).get_ref() != null:
			$SlashArea2D.add_to_group("Fireball")
			$SlashArea2D.add_to_group(str(PLAYER.ATTACK * (Global.player_skill_multipliers["SulphuricSigilSingleSlash"] / 100)))
			print("ADDED")
					

func _ready():
	set_attack_power()
	$DurationTimer.start()
	$SecondSlash.visible = false
	$FirstSlash.visible = false
	if Global.player_talents["InfernalMark"]["unlocked"] and Global.player_talents["InfernalMark"]["enabled"]:
		if weakref(get_parent()).get_ref() != null:
			get_parent().debuff_damage_multiplier += (Global.player_talents["InfernalMark"]["DamageIncrease"] / 100)
#			print("huzzah: " + str(get_parent().global_res))
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("EnemyEntity"):
		body.add_to_group("MarkedWithSulphuricSigil")
	
func _on_DurationTimer_timeout():
	get_parent().remove_from_group("MarkedWithSulphuricSigil")
	$AnimationPlayer.play("Destroy")


func trigger_slash():
#	set_attack_power()
	$SlashAnimationPlayer.play("SulphuricSigilSlash")
	if Global.player_talents["InfernalMark"]["unlocked"] and Global.player_talents["InfernalMark"]["enabled"]:
		if weakref(get_parent()).get_ref() != null:
			get_parent().debuff_damage_multiplier -= (Global.player_talents["InfernalMark"]["DamageIncrease"] / 100)

func _on_Area2D_area_entered(area):
	if area.is_in_group("SulphuricSigilTrigger"):
#		if Global.player_talents["HellishFervor"]["unlocked"] and Global.player_talents["HellishFervor"]["enabled"]:
		trigger_slash()
		get_parent().remove_from_group("MarkedWithSulphuricSigil")
	
	if area.is_in_group("Sword") or area.is_in_group("SwordCharged") or area.is_in_group("Fireball") or area.is_in_group("Ice") or area.is_in_group("Earth") or area.is_in_group("Lightning"):
		connect("add_meter_to_firefairy", fire_fairy, "add_meter_value")
		emit_signal("add_meter_to_firefairy", Global.player_skill_multipliers["FireFairyMeterGainFromSigil"])
		print("ADD METER")
