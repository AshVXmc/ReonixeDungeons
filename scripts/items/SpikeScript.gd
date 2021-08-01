extends StaticBody2D

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		yield(get_tree().create_timer(0.4),"timeout")
		get_tree().reload_current_scene()
		
