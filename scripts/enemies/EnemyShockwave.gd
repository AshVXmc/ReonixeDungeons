class_name EnemyShockwave extends Area2D

const TYPE : String = "Shockwave"
const SPEED : int = 510
var velocity = Vector2()
onready var direction : int = 1


func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
#	if direction == -1:
#		$DirtParticles2D.rotation_degrees = -90


func _on_EnemyShockwave_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_DestroyedTimer_timeout():
	call_deferred('free')
