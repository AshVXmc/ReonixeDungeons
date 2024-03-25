class_name FireFairy extends Area2D
onready var player = get_parent().get_node("Player")
const SULPHURIC_SIGIL = preload("res://scenes/status_effects/SulphuricSigil.tscn")
const SPEED = 450
const steer_force = 225
var attack : int = 5
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var atkbonus : float
func _ready():
	add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["FireFairy"] / 100)))
	$AnimationPlayer.play("Flap")
	

func start(_transform, _target):
	global_transform = _transform
#	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * SPEED
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer
	else:
		return 0


func _physics_process(delta):
	if Input.is_action_just_pressed("secondary_skill"):
		position = player.global_position
	target = get_closest_enemy()
	if target and target.get_node("Area2D").overlaps_area($Detector):
		acceleration += seek()
	else:
		yield(get_tree().create_timer(8), "timeout")
		queue_free()
	velocity += acceleration * delta
	velocity = velocity.clamped(SPEED)
#	rotation = velocity.angle()
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

func _on_HomingOnEnemiesFireball_area_entered(area):
	pass

func _on_DestroyedTimer_timeout():
	queue_free() 


func _on_FireFairy_body_entered(body):
	if body.is_in_group("EnemyEntity") and !body.is_in_group("MarkedWithSulphuricSigil"):
		var sigil = SULPHURIC_SIGIL.instance()
		body.add_child(sigil)
