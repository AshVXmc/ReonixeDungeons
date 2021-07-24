extends KinematicBody2D

var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 100
const GRAVITY : int = 45
const LOOT : PackedScene = preload("res://scenes/items/HealthPot.tscn")

	
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
	if area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()

