class_name DamageBonusBuff extends Area2D

export (float) var amount
export (float) var duration
export (String, "Physical", "Ice", "Fire", "Earth") var type 

func _on_DamageBonusBuff_area_entered(area):
	if area.is_in_group("Player"):
		queue_free()

