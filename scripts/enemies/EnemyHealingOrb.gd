class_name EnemyHealingOrb extends Node2D

export var speed = 950
export var steer_force = 150.0
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null # the node of the enemy that the orb is supposed to be targeting. this makes sure that the orb won't collide with full health enemies


func _physics_process(delta):
	if target != null:
		var coordinates = target.position
		position = position.move_toward(coordinates, delta * speed)
	else:
		destroy()

func destroy():
	print(target)
	$CollisionShape2D.disabled = true
	$DestroyedTImer.stop()
	$Sprite.visible = false
	var bp = preload("res://scenes/particles/BlueSmokeParticle.tscn").instance()
	add_child(bp)
	bp.emitting = true
	bp.one_shot = true
	yield(get_tree().create_timer(bp.lifetime), "timeout")
	call_deferred('free')
	

func _on_DestroyedTImer_timeout():
	destroy()


func _on_EnemyHealingOrb_body_entered(body):
	if body.is_in_group("EnemyEntity") and body.is_in_group("CanBeHealed"):
		destroy()
