class_name Shuriken extends Area2D

export var X_rot : float = 0
export var Y_rot : float = 0
const SPEED : int = 500


var velocity := Vector2(X_rot, Y_rot)
var is_up : bool = false
var x_direction : int = 1

func _ready():
	$AnimationPlayer.play("Shuriken")

func _physics_process(delta):
	if is_up:
		velocity.y = -SPEED * delta
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
	if area.is_in_group("Player") or area.is_in_group("Sword"):
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
