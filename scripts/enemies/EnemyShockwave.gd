class_name EnemyShockwave extends Area2D

const TYPE : String = "Shockwave"
var speed : int = 1125
var velocity = Vector2()
var direction : int = 1
var elemental_type : String = "Physical"
var atk_value : float = 2 * Global.enemy_level_index + 1.25


func _physics_process(delta):
	if direction == 1:
		$Sprite.flip_h = true
	elif direction == -1:
		$Sprite.flip_h = false
	velocity.x = speed * delta * -direction
	translate(velocity)
	

func _on_EnemyShockwave_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_DestroyedTimer_timeout():
	call_deferred('free')
