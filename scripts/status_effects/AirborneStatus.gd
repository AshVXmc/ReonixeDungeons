class_name AirborneStatus extends Node2D



func _on_DestroyedTimer_timeout():
	queue_free()
