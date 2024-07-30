class_name AgnetteArrow extends KinematicBody2D

const MAX_SPEED : int = 350
var SPEED : int = MAX_SPEED
var velocity := Vector2()
export (int) var x_direction = 1
const TYPE = "Physical"

func _ready():
	pass

func _physics_process(delta):
	position += transform.x * SPEED * delta * x_direction
	$Sprite.flip_h = true if x_direction < 0 else false
	velocity.x = SPEED * delta * x_direction
	translate(velocity)


func flip_arrow_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction


func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		call_deferred('free')


func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_Timer_timeout():
	call_deferred('free')



func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED
