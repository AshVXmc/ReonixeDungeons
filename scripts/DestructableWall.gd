extends StaticBody2D


const TYPE = "DestructableWall"


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		queue_free()
