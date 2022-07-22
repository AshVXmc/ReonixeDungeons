class_name IceLance extends Area2D

onready var player = get_parent().get_node("Player")
var SPEED = 850
const steer_force = 225
var attack : int = 5
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
onready var left : bool = true
onready var right : bool = false

# How the skill works:
# The player throws a spinning ice lance forwards (left or right).
# After some time, the ice lance homes towards the player and gets destroyed upon contact with the player.


func _physics_process(delta):
	if !$TargetPlayerTimer.is_stopped():
		if right:
			velocity.x = SPEED * delta
		elif left:
			velocity.x = -SPEED * delta
		translate(velocity)
