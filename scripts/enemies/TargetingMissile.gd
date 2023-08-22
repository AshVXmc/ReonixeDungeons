class_name TargetingMissile extends Node2D

func _ready():
	$ExplosionParticle.visible = false
	yield(get_tree().create_timer(0.5),"timeout")
	$AnimationPlayer.play("Pulse")
	yield(get_tree().create_timer(1),"timeout")
	$Area2D.add_to_group("Enemy")
	$Crosshair.visible = false
	$ExplosionParticle.visible = true
	$ExplosionParticle.emitting = true
	yield(get_tree().create_timer(0.5),"timeout")
	queue_free()
	


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
