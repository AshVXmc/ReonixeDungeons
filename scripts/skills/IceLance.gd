class_name IceLance extends Area2D

onready var player = get_parent().get_node("Player")
var SPEED = 800
const steer_force = 700
var attack : int = 5
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
onready var direction
onready var atkbonus
enum {
	Left, Right
}




# How the skill works:
# The player throws a spinning ice lance forwards (left or right).
# After some time, the ice lance homes towards the player and gets destroyed upon contact with the player.
func _ready():
	direction = Right
	add_to_group(str(Global.glaciela_attack))
func _physics_process(delta):
	if !$TargetPlayerTimer.is_stopped():
		if direction == Right:
			velocity.x = SPEED * delta
		elif direction == Left:
			velocity.x = -SPEED * delta
		translate(velocity)
	else:
#		SPEED *= 2
		target = get_parent().get_node("Player")
		if target:
			acceleration += seek_player()
			velocity += acceleration * delta
			velocity = velocity.clamped(SPEED)
			position += velocity * delta
		
func seek_player():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer




func _on_PlayerDetector_area_entered(area):
	if area.is_in_group("Player") and $TargetPlayerTimer.is_stopped():
		queue_free()


func _on_DestroyedTimer_timeout():
	queue_free()
