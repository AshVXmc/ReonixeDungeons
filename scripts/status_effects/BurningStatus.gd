class_name BurningStatus extends Area2D

func _ready():
	$DamageTickTimer.start()

func _on_DamageTickTimer_timeout():
	if !$CollisionShape2D.disabled:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false


func _on_DestroyedTimer_timeout():
	queue_free()


func _on_BurningStatus_area_entered(area):
	pass # Replace with function body.
