class_name RainOfArrows extends Node2D




func _on_Timer_timeout():
	$Area2D/CollisionShape2D.disabled = true if !$Area2D/CollisionShape2D.disabled else false


func _on_DestroyedTimer_timeout():
	call_deferred('free')
