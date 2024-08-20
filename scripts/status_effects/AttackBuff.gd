class_name AttackBuff extends Area2D

export (float) var amount
export (float) var duration
export (String, "Flat", "Percentage") var type 
export (bool) var is_a_debuff = false
# PICKING UP A NEW ATTACK BUFF CRYSTAL WILL REPLACE CURRENT ATTACK BUFF, SO BE CAREFUL
export (bool) var destroy_after_contact = true

func _on_AttackBuff_area_entered(area):
	if area.is_in_group("Player") and destroy_after_contact:
		call_deferred('free')
