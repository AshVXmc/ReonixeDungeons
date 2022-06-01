class_name FireSaw extends Area2D

var SPEED : int = 500
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false

func _ready():
	$Timer.start()
	$AnimationPlayer.play("SPIN")
	$DestroyedTimer.start()

func _on_DestroyedTimer_timeout():
	queue_free()


func _on_Timer_timeout():
	if !$CollisionPolygon2D.disabled:
		$CollisionPolygon2D.disabled = true
	else:
		$CollisionPolygon2D.disabled = false
