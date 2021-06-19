extends KinematicBody2D

var velocity = Vector2()
var direction : int = 1

const FLOOR = Vector2(0, -1)
const SPEED : int = 100
const GRAVITY : int = 45

func _ready():
	pass 
	
func _physics_process(delta):
	velocity.x = SPEED * direction
	
	if direction == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("slimeanim")
	
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1	
	
	
