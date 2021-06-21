extends KinematicBody2D


var velocity = Vector2(0,0)
var is_attacking : bool = false
var is_dead : bool = false

const SPEED : int = 275
const GRAVITY : int = 45
const JUMP_POWER : int = -1100

func _physics_process(delta):
	# Makes sure the player is alive to use any movement controls
	if is_dead == false:
		# Movement controls
		if Input.is_action_pressed("right") and is_attacking == false:
			velocity.x = SPEED;
			$Sprite.play("Walk")
			$Sprite.flip_h = false
			if Input.is_action_just_released("right"):
				$Sprite.play("Walk")
			
			# Collision flipping 
			get_node("AttackCollision").set_scale(Vector2(1,1))
			
		elif Input.is_action_pressed("left") and is_attacking == false:
			velocity.x = -SPEED;
			$Sprite.play("Walk")
			$Sprite.flip_h = true
			
			# Collision flipping (Left)
			get_node("AttackCollision").set_scale(Vector2(-1,1))
		elif velocity.x == 0:
			if is_attacking == false:
				  $Sprite.play("Idle")
		
		# Jump controls
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_POWER
			$Sprite.play("Idle")
			is_attacking = false
			
		# Attack controls		
		if Input.is_action_just_pressed("ui_accept"):
			$Sprite.play("Attack")
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
		
		# Movement calculations
		velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.2)
		
		# Player Death
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Slime" in get_slide_collision(i).collider.name:
					dead() 

func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$Sprite.play("Dead")
	$CollisionShape2D.disabled = true
	$Timer.start()
	

# Attack animation handling + collision
func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack":
		$AttackCollision/CollisionShape2D.disabled = true
		is_attacking = false
		
# Handles what happens when the timer runs out
func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/MainMenu.tscn") 
	
