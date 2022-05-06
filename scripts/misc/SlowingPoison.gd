class_name SlowingPoison extends Area2D

const TYPE : String = "SlowingPoison"
var SPEED : int = 500
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false

func _ready():
	$SlowPoisonParticle.visible = false
	$AnimationPlayer.play("Spin")
func _physics_process(delta):
	if !destroyed:
		velocity.x = SPEED * delta * direction
	else:
		velocity.x = 0
	translate(velocity)


func _on_Timer_timeout():
	destroyed = true
	$Sprite.visible = false
	$AnimationPlayer.stop()
	$Area2D/CollisionShape2D.disabled = false
	$SlowPoisonParticle.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()
