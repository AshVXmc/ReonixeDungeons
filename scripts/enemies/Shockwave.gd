extends Area2D

const TYPE : String = "Shockwave"
const SPEED : int = 500
var velocity = Vector2()
var direction : int = 1

func _ready():
	add_to_group(str(Global.agnette_attack * (Global.agnette_skill_multipliers["BearFormShockwave"] / 100)))
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)

func flip_sw(sw_direction : int):
	direction = sw_direction
	if sw_direction == -1:
		$Sprite.flip_h = true
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Shockwave_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_DestroyedTimer_timeout():
	call_deferred('free')
