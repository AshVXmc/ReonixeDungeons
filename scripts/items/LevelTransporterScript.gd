extends StaticBody2D


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		get_tree().change_scene("res://scenes/levels/Level" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
		


