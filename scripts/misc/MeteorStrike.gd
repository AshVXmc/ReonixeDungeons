class_name MeteorStrike extends Area2D

var velocity = Vector2()
var SPEED = 750
var is_destroyed : bool = false
var smash_direction

enum Direction {
	Left, Right
}

func _ready():
	get_parent().get_node("Player").cam_shake = true
	$ExplosionDelayTimer.start()
	$DestroyedTimer.start()
	$AnimationPlayer.play("Spin")
	$LeftTrails.visible = true

func _physics_process(delta):
	if !is_destroyed:
		velocity.x = SPEED * delta
		velocity.y = 7.5
		translate(velocity)

func explode():
	$Sprite.visible = false
	is_destroyed = true
	$ExplosionParticle.emitting = true
	$CollisionShape2D.disabled = false
	$LeftTrails.visible = false
	
	yield(get_tree().create_timer(0.75), "timeout")
	get_parent().get_node("Player").cam_shake = false
	call_deferred('free')

func _on_DestroyedTimer_timeout():
	explode()


func _on_ExplosionDelayTimer_timeout():
	pass # Replace with function body.




func _on_DetectorArea_body_entered(body):
	if body.is_in_group("TileMap"):
		explode()
