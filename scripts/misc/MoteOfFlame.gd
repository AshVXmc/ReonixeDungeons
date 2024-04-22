class_name MoteOfFlame extends AnimatedSprite


func _ready():
	play("default")
	yield(get_tree().create_timer($Timer.wait_time * 0.7), "timeout")
	$AnimationPlayer.play("flicker")
func explode():
	call_deferred('free')

func _on_Timer_timeout():
	explode()
