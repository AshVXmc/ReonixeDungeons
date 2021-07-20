extends KinematicBody2D

var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false
# If the health reaches 0 the enemy dies
var health : int = 1

const TYPE : String = "Slime"
const FLOOR = Vector2(0, -1)
const SPEED : int = 100
const GRAVITY : int = 45

func _ready():
	pass
	
func _physics_process(delta):
	
	
	velocity.x = SPEED * direction
	
	if direction == 1 and !is_dead:
		$AnimatedSprite.flip_h = false
	elif !is_dead:
		$AnimatedSprite.flip_h = true
	
	if !is_dead:	
		$AnimatedSprite.play("slimeanim")
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

					
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and health > 0:
		health -= 1
	elif health <= 0:
		is_dead = true
		$AnimatedSprite.play("death")
	
	if health <= 0:
		is_dead = true
		$AnimatedSprite.play("death")
			
func _on_AnimatedSprite_animation_finished():
	if is_dead:
		queue_free()	


func _on_Timer_timeout():
	queue_free()
