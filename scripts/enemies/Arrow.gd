class_name Arrow extends Area2D


const SPEED : int = 500
var velocity := Vector2()
var x_direction : int = 1


	
func _physics_process(delta):
	position += transform.x * SPEED * delta * x_direction
	if x_direction < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
#	velocity.x = SPEED * delta * x_direction
	translate(velocity)

func flip_arrow_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()



func _on_Arrow_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()
