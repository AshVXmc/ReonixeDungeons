class_name LootBag extends RigidBody2D

signal player_obtained_lootbag(player_opals, amount)
onready var Tier : int = 1
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var SPEED = 550
const steer_force = 300
onready var PLAYER = get_parent().get_node("Player")
enum Rewards {
	C = 20
	B = 30
	A = 50
	S = 80
	SS = 100
	SSS = 120
}

func _ready():
	target = PLAYER
	connect("player_obtained_lootbag", get_parent().get_node("OpalsUI/OpalsControl"), "on_player_opals_obtained")
#func start(_transform, _target):
#	global_transform = _transform
##	rotation += rand_range(-0.09, 0.09)
#	velocity = transform.x * SPEED
#	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer
	else:
		return 0
func _physics_process(delta):
	if target:
		acceleration += seek()
	velocity += acceleration * delta
	rotation += rand_range(-0.25, 0.25)
	velocity = velocity.clamped(SPEED)
	position += velocity * delta
	

func reward_opals():
	var amount : int
	match Global.elegance_rank:
		"C":
			amount = Rewards.C
		"B":
			amount = Rewards.B
		"A":
			amount = Rewards.A
		"S":
			amount = Rewards.S
		"SS":
			amount = Rewards.SS
		"SSS":
			amount = Rewards.SSS
	Global.opals_amount += amount
	emit_signal("player_obtained_lootbag", Global.opals_amount, amount)
	call_deferred('free')

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		reward_opals()


func _on_IncreaseSpeedTimer_timeout():
	SPEED *= 1.2
