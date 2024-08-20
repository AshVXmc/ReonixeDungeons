class_name SeekingArrow extends KinematicBody2D

const MAX_SPEED : int = 450
var SPEED : int = MAX_SPEED
var velocity := Vector2()
export (int) var x_direction = 1
const TYPE = "Physical"
onready var agnette = get_parent()
signal add_mana_to_agnette(amount)
onready var mana_granted : float = 0.25

func _ready():
	connect("add_mana_to_agnette", get_parent().get_node("Player/CharacterManager/Agnette"), "change_mana_value")

onready var player = get_parent().get_node("Player")
export var speed = 800
export var steer_force = 600.0

var acceleration = Vector2.ZERO
var target = null

# attack value is calculated in the chaos magic UI.

	
	
func start(_transform, _target):
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	

func _physics_process(delta):
	target = get_closest_enemy()
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("EnemyEntity")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = player.global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy

func explode():
	print("KABOOM")
	call_deferred('free')

func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_Timer_timeout():
	call_deferred('free')



func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED
