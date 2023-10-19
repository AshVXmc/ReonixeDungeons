class_name EnemyHealingOrb extends Node2D

export var speed = 750
export var steer_force = 150.0
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null # the node of the enemy that the orb is supposed to be targeting. this makes sure that the orb won't collide with full health enemies


func get_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("CanBeHealed")
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

func _physics_process(delta):
	target = get_closest_enemy()
	if target:
		var coordinates = target.position
		position = position.move_toward(coordinates, delta * speed)
	else:
		call_deferred('free')

func destroy():
	$CollisionShape2D.disabled = true
	$DestroyedTImer.stop()
	$Sprite.visible = false
	var bp = preload("res://scenes/particles/BlueSmokeParticle.tscn").instance()
	add_child(bp)
	bp.emitting = true
	bp.one_shot = true
	yield(get_tree().create_timer(bp.lifetime), "timeout")
	call_deferred('free')
	

func _on_DestroyedTImer_timeout():
	destroy()


func _on_EnemyHealingOrb_body_entered(body):
	if body.is_in_group("EnemyEntity") and body.is_in_group("CanBeHealed") and body.HP < body.max_HP:
		destroy()
