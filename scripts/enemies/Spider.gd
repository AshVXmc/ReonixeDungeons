class_name Spider extends KinematicBody2D

export var HP : int = 2
var velocity : Vector2 = Vector2()
var is_dead : bool = false 
var direction : int = 1
var jumping : int = 1
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, 1)
const SPEED : int = -100
const GRAVITY : int = -45

func _ready():
	$JumpTimer.start()
func _physics_process(delta):
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	if direction == 1 and !is_dead:
		$AnimatedSprite.flip_h = false
	elif !is_dead:
		$AnimatedSprite.flip_h = true
	if !is_dead:
		$AnimatedSprite.play("slimeanim")
	
	
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall() or !$RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1



