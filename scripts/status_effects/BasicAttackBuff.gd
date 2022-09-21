class_name BasicAttackBuff extends Area2D

export (float) var amount
export (float) var duration
# PICKING UP A NEW ATTACK BUFF CRYSTAL WILL REPLACE CURRENT ATTACK BUFF, SO BE CAREFUL

func _on_AttackBuff_area_entered(area):
	if area.is_in_group("Player"):
		queue_free()
