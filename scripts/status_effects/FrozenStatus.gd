class_name FrozenStatus extends Area2D

func _ready():
	yield(get_tree().create_timer(1.25), "timeout")
	queue_free()

