class_name LargeFireball extends Area2D

const TYPE : String = "Fireball"
var SPEED : int = 500
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false

func _physics_process(delta):
	if !destroyed:
		velocity.x = SPEED * delta * direction
		$AnimatedSprite.play("Shoot")
	else:
		velocity.x = 0
	translate(velocity)
		

func override_speed(ovr_speed : int):
	SPEED = ovr_speed

func flip_projectile(p_direction : int):
	direction = p_direction
	if p_direction == -1:
		$AnimatedSprite.flip_h = true
			
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Enemy2") or area.is_in_group("DestructableObject") or area.is_in_group("Campfire"):
		destroyed = true
		$AnimatedSprite.play("Destroyed")
		$CollisionShape2D.disabled = true
		yield(get_tree().create_timer(0.25), "timeout")
		queue_free()


func _on_Fireball_body_entered(body):
	destroyed = true
	$AnimatedSprite.play("Destroyed")
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.25), "timeout")
	queue_free()

func _on_DestroyedTimer_timeout():
	queue_free()
