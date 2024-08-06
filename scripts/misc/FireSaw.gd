class_name FireSaw extends Area2D

const BURNING : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
var SPEED : int = 500
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false
const SMALL_FIRE_PARTICLE : PackedScene = preload("res://scenes/particles/FireHitParticle.tscn")
var atkbonus : float
var attack_calculation : float
#var burn_coefficient : float

func _ready():
#	add_burning_stack(true)
#	print($BurningBreathTalentDetector.get_overlapping_bodies())
	$DestroyedTimer.start(Global.player_skill_multipliers["FireSawDuration"])
	get_parent().add_to_group("FiresawActive")
	if Global.equipped_characters[0] == "Player":
#		burncalculation = Global.attack_power * burn_coefficient
		attack_calculation = Global.attack_power * (Global.player_skill_multipliers["FireSaw"] / 100) + atkbonus
	add_to_group(str(attack_calculation))
	$AnimationPlayer.play("SPIN")
	
func _on_DestroyedTimer_timeout():
	get_parent().remove_from_group("FiresawActive")
	call_deferred('free')

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
	var enemy = get_overlapping_areas()
	for e in enemy:
		if e.is_in_group("Enemy"):
			if !e.is_in_group("Burnstack"):
				var burning_status = BURNING.instance()
				e.add_child(burning_status)


func _on_FireSaw_area_entered(area):
	if area.is_in_group("Enemy"):
		add_burning_stack()
		var fire_hit_particle = SMALL_FIRE_PARTICLE.instance()
		get_parent().get_parent().add_child(fire_hit_particle)
		fire_hit_particle.emitting = true
		fire_hit_particle.position = get_closest_enemy().global_position 


	
