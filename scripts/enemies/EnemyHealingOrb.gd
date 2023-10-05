class_name EnemyHealingOrb extends Node2D

export var speed = 350
export var steer_force = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func start(_transform, _target):
	global_transform = _transform
	velocity = transform.x * speed
	target = _target

func get_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("EnemyEntity")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
		return steer
	else:
		return 0

func _physics_process(delta):
	target = get_closest_enemy()
	if target and target.get_node("Area2D").overlaps_area($Detector):
		acceleration += seek()
	else:
		yield(get_tree().create_timer(8), "timeout")
		queue_free()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
#	rotation = velocity.angle()
	position += velocity * delta
