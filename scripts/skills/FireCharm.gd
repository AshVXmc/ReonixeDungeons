class_name FireCharm extends Node2D


const MAX_SPEED : int = 300
var SPEED : int = MAX_SPEED
var velocity := Vector2()
export (int) var x_direction = 1
var stopped : bool = false
func _ready():
	$DestroyedTimer.wait_time = Global.player_skill_multipliers["FireCharmDuration"]
	$DestroyedTimer.start()
func _physics_process(delta):
	if !stopped:
		position += transform.x * SPEED * delta * x_direction
		if x_direction < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	#	velocity.x = SPEED * delta * x_direction
		translate(velocity)

func stop_charm():
	stopped = true
	$Sprite.rotation_degrees = 0

func flip_arrow_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction


func _on_Area2D_area_entered(area):
	if area.is_in_group("TileMap"):
		stop_charm()

func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED


func _on_DestroyedTimer_timeout():
	call_deferred('free')


func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap"):
		stop_charm()


func _on_StopMovingTimer_timeout():
	stop_charm()
