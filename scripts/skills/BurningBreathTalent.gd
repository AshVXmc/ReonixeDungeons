class_name BurningBreathTalent extends Node2D

const BURNING : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
const SMALL_FIRE_PARTICLE : PackedScene = preload("res://scenes/particles/FireHitParticle.tscn")
var direction : int = 1

func _ready():
	$Area2D.add_to_group(str(Global.attack_power * (Global.player_talents["BurningBreath"]["attackpercentage"] / 100)))
	if direction == 1:
		rotation_degrees = 0
	elif direction == -1:
		rotation_degrees = 180
	
	$DestroyTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("EnemyEntity")
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



func add_burning_stack():
	var enemy = $Area2D.get_overlapping_areas()
	for e in enemy:
		if e.is_in_group("Enemy"):
			if !e.is_in_group("Burnstack"):
				var burning_status = BURNING.instance()
				e.add_child(burning_status)


func _on_DestroyTimer_timeout():
	call_deferred('free')


func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		add_burning_stack()
		var fire_hit_particle = SMALL_FIRE_PARTICLE.instance()
		get_parent().get_parent().add_child(fire_hit_particle)
		fire_hit_particle.emitting = true
		fire_hit_particle.position = get_closest_enemy().global_position 
