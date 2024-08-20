class_name ConeOfCold extends Node2D

var active : bool = false
onready var resource_meter_ui : TextureProgress = get_parent().get_parent().get_parent().get_parent().get_node("SkillsUI/Control/TertiarySkill/Glaciela/ConeOfCold/ConeOfColdResource")
var slowdown_coefficient : float = Global.glaciela_skill_multipliers["ConeOfColdMovementSpeedPenalty"] / 100

func _ready():
	print(get_path())
	print("brr:" + str(Global.glaciela_skill_multipliers["ConeOfCold"] / 100 * Global.glaciela_attack))
	$Area2D.add_to_group(str(Global.glaciela_skill_multipliers["ConeOfCold"] / 100 * Global.glaciela_attack))
	
	$FreezeGaugeArea.add_to_group(str(Global.glaciela_skill_multipliers["ConeOfColdFreezeGauge"]))
#	deactivate_cone_of_cold()

func activate_cone_of_cold():
	active = true
	$SelfSnareArea.remove_from_group("ConeOfColdSnareOff")
	$SelfSnareArea.add_to_group("ConeOfColdSnareOn")
	$SelfSnareArea/CollisionShape2D.disabled = false
	$FrostBurstParticle.visible = true
	$FrostBurstParticle.emitting = true
	$Area2D/CollisionPolygon2D.disabled = false
	$FreezeGaugeArea/CollisionPolygon2D.disabled = false
	$DamageTickTimer.start()
	yield(get_tree().create_timer(0.1), "timeout")
	$SelfSnareArea/CollisionShape2D.disabled = true

func deactivate_cone_of_cold():
	active = false
	$SelfSnareArea.remove_from_group("ConeOfColdSnareOn")
	$SelfSnareArea.add_to_group("ConeOfColdSnareOff")
	$SelfSnareArea/CollisionShape2D.disabled = false
	$FrostBurstParticle.visible = false
	$FrostBurstParticle.emitting = false
	$Area2D/CollisionPolygon2D.disabled = true
	$FreezeGaugeArea/CollisionPolygon2D.disabled = true
	$DamageTickTimer.stop()
	yield(get_tree().create_timer(0.1), "timeout")
	$SelfSnareArea/CollisionShape2D.disabled = true

func _process(delta):
	if active and Global.current_character == "Glaciela":
		if !get_parent().get_node("AnimatedSprite").flip_h:
			rotation_degrees = 0
			position.x = 45
		else:
			rotation_degrees = 180
			position.x = -45
		
func _on_Area2D_area_entered(area):
	pass # Replace with function body.



func _on_DamageTickTimer_timeout():
	if active:
		if Global.current_character == "Glaciela" and resource_meter_ui.value > 0:
			$Area2D/CollisionPolygon2D.disabled = true if !$Area2D/CollisionPolygon2D.disabled else false
			$FreezeGaugeArea/CollisionPolygon2D.disabled = true if !$FreezeGaugeArea/CollisionPolygon2D.disabled else false
			$DamageTickTimer.start()
			resource_meter_ui.value = clamp(resource_meter_ui.value - Global.glaciela_skill_multipliers["ConeOfColdResourceConsumption"], 0, resource_meter_ui.max_value)
#			get_parent().change_mana_value(-Global.glaciela_skill_multipliers["ConeOfColdManaConsumed"])
		else:
			get_parent().emit_signal("skill_used", "ConeOfCold", 0, -1)
			get_parent().get_parent().get_parent().emit_signal("skill_ui_update", "ConeOfCold")
#
#		if !get_parent().get_node("AnimatedSprite").flip_h:
#			rotation_degrees = 0
#			position.x = 45
#		else:
#			rotation_degrees = 180
#			position.x = -45

#func get_glaciela_current_mana():
#	if Global.equipped_characters[0] == "Glaciela":
#		return Global.mana
#	elif Global.equipped_characters[1] == "Glaciela":
#		return Global.character2_mana
#	elif  Global.equipped_characters[2] == "Glaciela":
#		return Global.character3_mana
