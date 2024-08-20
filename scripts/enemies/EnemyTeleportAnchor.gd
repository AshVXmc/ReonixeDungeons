class_name EnemyTeleportAnchor extends KinematicBody2D

const MAX_SPEED : int = 250
const GRAVITY : int = 0
var SPEED : int = MAX_SPEED
var velocity := Vector2()
export (int) var x_direction = 1
var stopped : bool = false
var used : bool = false
func _ready():
	print("sending anchor")

func _physics_process(delta):
	if !stopped:
		position += transform.x * SPEED * delta * x_direction
		position.y += GRAVITY
	#	velocity.x = SPEED * delta * x_direction
		translate(velocity)

func stop_anchor():
#	$TeleportParticles.emitting = true
	stopped = true
#	$Sprite.rotation_degrees = 0

func destroy_anchor():
#	$TeleportParticles.one_shot = true
#	$TeleportParticles.emitting = true
	yield(get_tree().create_timer(0.7), "timeout")
	call_deferred('free')
	
func flip_anchor_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction


func _on_Area2D_area_entered(area):
	if area.is_in_group("TileMap"):
		stop_anchor()

func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED


func _on_DestroyedTimer_timeout():
	call_deferred('free')


func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap"):
		stop_anchor()


func _on_StopMovingTimer_timeout():
	stop_anchor()
