extends KinematicBody2D

var velocity = Vector2(0,0)
var is_attacking : bool = false

const SPEED : int = 275
const GRAVITY : int = 45
const JUMP_POWER : int = -1100

func _physics_process(delta):
	if Input.is_action_pressed("right") and is_attacking == false:
		velocity.x = SPEED;
		$Sprite.play("Walk")
		$Sprite.flip_h = false
		if Input.is_action_just_released("right"):
			$Sprite.play("Walk")
		
		# Collision flipping
		if $AttackCollision/CollisionShape2D.position.x < 0:
			$AttackCollision/CollisionShape2D.position.x *= -1
		else:
			$AttackCollision/CollisionShape2D.position.x *= 1		
			
	elif Input.is_action_pressed("left") and is_attacking == false:
		velocity.x = -SPEED;
		$Sprite.play("Walk")
		$Sprite.flip_h = true
		
		# Collision flipping
		if $AttackCollision/CollisionShape2D.position.x > 0:
			$AttackCollision/CollisionShape2D.position.x *= -1
		else:
			$AttackCollision/CollisionShape2D.position.x *= 1	
		
	elif velocity.x == 0:
		if is_attacking == false:
			  $Sprite.play("Idle")
			
	if Input.is_action_just_pressed("ui_accept"):
		$Sprite.play("Attack")
		
		is_attacking = true
		$AttackCollision/CollisionShape2D.disabled = false
		
				

	if not is_on_floor():
		$Sprite.play("Idle")
			
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_POWER
		$Sprite.play("Idle")
		is_attacking = false
	
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack":
		$AttackCollision/CollisionShape2D.disabled = true
		is_attacking = false
