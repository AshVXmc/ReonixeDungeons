class_name JumpParticle extends CPUParticles2D



func _on_Timer_timeout():
	call_deferred('free')
