class_name Bat extends KinematicBody2D

const TYPE : String = "Enemy"
const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")
var SPEED : int = 3.5
var steer_force = 120
var velocity: Vector2 = Vector2.ZERO
var is_dead : bool = false
var max_HP = 100
var HP : int = max_HP
var direction : int = 1
var player = null
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var target = null
var acceleration = Vector2()
var is_staggered : bool = false
var phys_res : float = 25
var fire_res : float = 0
var earth_res : float = 0 
var ice_res : float = 0
var magic_res : float = -50
var is_frozen
var is_attacking : bool

# NOTE: Collision mask for the raycast2d is set to 8 since layer 8 is exclusive to the player/
func _ready():
	$AnimatedSprite.play("Idle")


func _physics_process(delta):
	
	if !get_tree().get_nodes_in_group("Decoy").empty():
		target = get_decoy()
	else:
		target = get_player()
	if !is_staggered and target == get_player():
		if !is_attacking:
			if target.global_position.x < global_position.x - 50 and target.global_position.x != global_position.x:
				velocity.x = -SPEED
			elif target.global_position.x > global_position.x + 50 and target.global_position.x != global_position.x:
				velocity.x = SPEED
			elif target.global_position.x == global_position.x:
				velocity.x = 0
		if $RayCast2D.is_colliding():
			velocity.x = 0
			projectile_attack()
		translate(velocity)
		
func _on_ProjectileAttackTimer_timeout():
	pass # Replace with function body.

func projectile_attack():
	pass
func get_decoy():
	var decoy = get_parent().get_node("Decoy")
	return decoy
func get_player():
	var player = get_parent().get_node("Player")
	return player
func add_damage_particles(type : String, dmg : int):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.damage_type = type
	dmgparticle.damage = dmg
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position

func parse_status_effect_damage():
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0:
		call_deferred('free')

func _on_Area2D_area_entered(area):
	var groups_to_remove : Array = [
		"Sword", "SwordCharged", "Fireball", "Ice",
		"physics_process", "FireGauge", "FireGaugeTwo", "LightKnockback"
	]
	if weakref(area).get_ref() != null:
		if area.is_in_group("Sword"):
				var groups : Array = area.get_groups()
				for group_names in groups:
					if float(group_names) != 0:
						var raw_damage = float(group_names)
#						if poise < MAX_POISE:
#							poise += 0.2 * MAX_POISE
						var damage = round((raw_damage - (raw_damage * (phys_res / 100))))
						print("HP reduced by " + str(damage))
						HP -= float(damage)
						$HealthBar.value  -= float(damage)
						add_damage_particles("Physical", float(damage))
						parse_damage()
						break
		
		if area.is_in_group("SwordCharged"):
				var groups : Array = area.get_groups()
				for group_names in groups:
					if float(group_names) == 0:
						groups.erase(group_names)
					if !groups.has("SwordCharged") and !groups.has("physics_process"):
						var raw_damage = float(groups.max())
						
						var damage = ((raw_damage - (raw_damage * (phys_res / 100))))
						print("HP reduced by " + str(damage))
						HP -= float(damage)
						$HealthBar.value  -= float(damage)
						add_damage_particles("Physical", float(damage))
						parse_damage()

						break
				
		if area.is_in_group("Fireball"):

				# YEAH IT WORKS EFJWFJWPOFWJPFWJP
				var groups : Array = area.get_groups()
				for group_names in groups:	
					if groups.has("Fireball"):
						groups.erase("Fireball")
					if groups.has("LightKnockback"):
						groups.erase("LightKnockback")
					if groups.has("physics_process"):
						groups.erase("physics_process")
					if !groups.has("Fireball") and !groups.has("FireGaugeOne") and !groups.has("physics_process"):
						print("HP reduced by " + str(groups.max()))
						HP -= float(groups.max())
					
						$HealthBar.value  -= float(groups.max())
						add_damage_particles("Fire", float(groups.max()))
						if area.is_in_group("LightKnockback"):
							parse_status_effect_damage()
						else:
							parse_damage()
						break
		if area.is_in_group("Ice"):
				
				# YEAH IT WORKS EFJWFJWPOFWJPFWJP
				var groups : Array = area.get_groups()
				for group_names in groups:
					if groups.has("Ice"):
						groups.erase("Ice")
					if groups.has("IceGaugeOne"):
						groups.erase("IceGaugeOne")
					if groups.has("IceGaugeTwo"):
						groups.erase("IceGaugeTwo")
					if groups.has("LightKnockback"):
						groups.erase("LightKnockback")
					if groups.has("physics_process"):
						groups.erase("physics_process")
					if !groups.has("Ice") and !groups.has("IceGaugeOne") and !groups.has("physics_process"):
						print("HP reduced by " + str(groups.max()))
						HP -= float(groups.max())
						
						$HealthBar.value  -= float(groups.max())
						add_damage_particles("Ice", float(groups.max()))
						if area.is_in_group("LightKnockback"):
							parse_status_effect_damage()
						else:
							parse_damage()
						break

		if area.is_in_group("FireGauge"):
			pass
		if area.is_in_group("Burning"):
			print("Burning")
			var damage = (0.025 * max_HP) + (Global.damage_bonus["fire_dmg_bonus_%"] / 100 * (0.025 * max_HP))
			HP -= damage
	
			print("HP-" + str(damage))
			$HealthBar.value -= damage
			parse_status_effect_damage()
			add_damage_particles("Fire", damage)
		
		if area.is_in_group("Player"):
				is_staggered = true
				yield(get_tree().create_timer(0.5), "timeout")
				is_staggered = false

		if area.is_in_group("Frozen"):
				is_frozen = true
		
		if area.is_in_group("TempusTardus"):
			SPEED *= 0.05
			velocity.y = 0
#			$Sprite.speed_scale = 0.1
		
		if area.is_in_group("LightPoiseDamage"):
			pass
		if area.is_in_group("MediumPoiseDamage"):
			pass
		if area.is_in_group("HeavyPoiseDamage"):
			pass

func parse_damage():
	if HP <= 0:
		drop_loot()
		call_deferred('free')
func drop_loot():
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,6)
	if randomint == 1:
		get_parent().add_child(loot)
		loot.position = $Position2D.global_position


# Player detector
#func _on_Detector_body_entered(body):
#	if body.get("TYPE") == "Player":
#		player = body 
#
#func _on_Detector_body_exited(body):
#	if body.get("TYPE") == "Player":
#		player = null 
#


func _on_HurtTimer_timeout():
	is_staggered = false




