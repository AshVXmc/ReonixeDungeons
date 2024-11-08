class_name EnemyShockwave extends Area2D

const TYPE : String = "Shockwave"
const SPEED : int = 580
var velocity = Vector2()
onready var direction : int = 1
var elemental_type : String = "Physical"
var atk_value : float = 2 * Global.enemy_level_index + 1.25

func _physics_process(delta):
	velocity.x = SPEED * delta * -direction
	translate(velocity)


func _on_EnemyShockwave_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_DestroyedTimer_timeout():
	call_deferred('free')