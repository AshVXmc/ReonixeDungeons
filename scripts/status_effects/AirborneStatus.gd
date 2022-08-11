class_name AirborneStatus extends Node2D

onready var time : float = 3

func _ready():
	print("airborne")
	$DestroyedTimer.start(time)


func _on_DestroyedTimer_timeout():
	queue_free()
