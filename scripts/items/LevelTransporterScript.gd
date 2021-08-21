extends StaticBody2D
onready var transition = get_parent().get_node("SceneTransition")
onready var colorrect = get_parent().get_node("SceneTransition/ColorRect")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		colorrect.visible = true
		transition.transition()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().queue_free()
		get_tree().change_scene("res://scenes/levels/Level" + str(int(get_tree().current_scene.name) + 1) + ".tscn")

