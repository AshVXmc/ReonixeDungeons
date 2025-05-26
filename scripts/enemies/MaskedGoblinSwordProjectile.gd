class_name MaskedGoblinSwordProjectile extends Area2D

const SPEED : float = 0.5
var velocity : Vector2 = Vector2(0,0)

func _physics_process(delta):
	velocity.y += SPEED
	translate(velocity)
