class_name FireSaw extends Area2D

var SPEED : int = 500
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false

func _ready():
	$AnimationPlayer.play("SPIN")
	$DestroyedTimer.start()

func _on_DestroyedTimer_timeout():
	queue_free()


