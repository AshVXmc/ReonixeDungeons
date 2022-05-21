class_name Shuriken extends Area2D

export var X_rot : float = 0
export var Y_rot : float = 0
const SPEED : int = 600


var velocity := Vector2(X_rot, Y_rot)
var is_up : bool = false
var right_up : bool = false
var right_up_2 : bool = false
var left_up_2 : bool = false
var left_up : bool = false
var x_direction : int = 1


func _ready():
	$AnimationPlayer.play("Shuriken")

func _physics_process(delta):
	if is_up:
		velocity.y = -SPEED * delta
	elif right_up:
		velocity.x = SPEED * delta * x_direction
		velocity.y = -3 * x_direction
	elif left_up:
		velocity.x = SPEED * delta * x_direction
		velocity.y = 3 * x_direction
	elif right_up_2:
		velocity.x = SPEED * delta * x_direction
		velocity.y = -5 * x_direction
	elif left_up_2:
		velocity.x = SPEED * delta * x_direction
		velocity.y = 3 * x_direction
	else:
		velocity.x = SPEED * delta * x_direction
	translate(velocity)

func flip_shuriken_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction

	
func set_rot(x : float = 0, y : float = 0):
	X_rot = x
	Y_rot = y

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
