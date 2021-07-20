extends StaticBody2D


const TYPE = "DestructableWall"


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()
