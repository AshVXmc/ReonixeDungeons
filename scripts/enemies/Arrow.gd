class_name Arrow extends KinematicBody2D


const MAX_SPEED : int = 400
var SPEED : int = MAX_SPEED
var velocity := Vector2()
export (int) var x_direction = 1


	
func _physics_process(delta):
	position += transform.x * SPEED * delta * x_direction
	if x_direction < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
#	velocity.x = SPEED * delta * x_direction
	translate(velocity)
	if is_on_wall():
		print("WALL")

func flip_arrow_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Fireball") or area.is_in_group("Tilemap"):
		queue_free()
	if area.is_in_group("Sword"):
		deflect()
	if area.is_in_group("TempusTardus"):
		SPEED *= 0.25

func deflect():
	x_direction *= -1
	SPEED = MAX_SPEED * 1.5
	remove_from_group("Projectile")
	$Area2D.add_to_group("Sword")
	$Area2D.add_to_group("50")
func _on_Arrow_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()


func _on_Timer_timeout():
	queue_free()





func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED
