extends KinematicBody2D

# Movement code go brrrr

var velocity = Vector2(0,0);
const SPEED : int = 275;
const GRAVITY : int = 45;
const JUMP_POWER : int = -1100;

func _physics_process(delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED;
		$Sprite.play("Walk")
		$Sprite.flip_h = false
		if Input.is_action_just_released("right"):
			$Sprite.play("Walk")
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED;
		$Sprite.play("Walk")
		$Sprite.flip_h = true
	elif velocity.x == 0:
		$Sprite.play("Idle")  
	
		
	if not is_on_floor():
		$Sprite.play("Walk")	
	
	
	velocity.y = velocity.y + GRAVITY;
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_POWER;	
	
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2);


