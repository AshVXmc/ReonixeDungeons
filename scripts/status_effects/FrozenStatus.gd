class_name FrozenStatus extends Area2D

func _ready():
	get_parent().remove_from_group("Enemy")
	yield(get_tree().create_timer(2), "timeout")
	get_parent().add_to_group("Enemy")
	queue_free()



func _on_FrozenStatus_area_entered(area):
	if area.is_in_group("Fireball"):
		get_parent().add_to_group("Enemy")
		queue_free()
