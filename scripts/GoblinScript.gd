extends KinematicBody2D

var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 200
const GRAVITY : int = 45
var player = null
var HP = 2

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

	if velocity.x == 0:
		$Sprite.play("Idle")
	else:
		$Sprite.play("Attacking")	

	if is_on_wall() or !$RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		$HurtTimer.start()
		if HP <= 0:
			queue_free()

func _on_Left_body_entered(body):
	$Sprite.flip_h = false
	if body.get("TYPE") == "Player":
		velocity.x -= 400

func _on_Right_body_entered(body):
	$Sprite.flip_h = true
	if body.get("TYPE") == "Player":
		velocity.x += 400

func _on_Left_body_exited(body):
	player = null
	$AttackingTimer.start()

func _on_Right_body_exited(body):
	player = null
	$AttackingTimer.start()

func _on_HurtTimer_timeout():
	set_modulate(Color(1,1,1,1))

func _on_AttackingTimer_timeout():
	velocity.x = 0
	
