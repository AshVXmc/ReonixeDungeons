extends Area2D

const TYPE : String = "Shockwave"
const SPEED : int = 750
var velocity = Vector2()
var direction : int = 1

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)

func flip_sw(sw_direction : int):
	direction = sw_direction
	if sw_direction == -1:
		$Sprite.flip_h = true
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

