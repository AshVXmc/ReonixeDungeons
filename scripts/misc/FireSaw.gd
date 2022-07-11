class_name FireSaw extends Area2D

var SPEED : int = 500
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false
const SMALL_FIRE_PARTICLE : PackedScene = preload("res://scenes/particles/FireHitParticle.tscn")

func _ready():
	$AnimationPlayer.play("SPIN")

func _on_DestroyedTimer_timeout():
	queue_free()

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = get_parent().global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy

func _on_FireSaw_area_entered(area):
	if area.is_in_group("Enemy"):
		print("firesaw particle")
		var fire_hit_particle = SMALL_FIRE_PARTICLE.instance()
		get_parent().get_parent().add_child(fire_hit_particle)
		fire_hit_particle.emitting = true
		print(get_closest_enemy().global_position)
		fire_hit_particle.position = get_closest_enemy().global_position 
