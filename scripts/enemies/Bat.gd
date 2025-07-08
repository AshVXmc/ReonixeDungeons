class_name Bat extends BaseEnemy


const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")

var steer_force = 120
var velocity: Vector2 = Vector2.ZERO




var is_dead : bool = false
var direction : int = 1
var is_near_player : bool = false
var player = null

const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
const PROJECTILE : PackedScene = preload("res://scenes/misc/BatProjectile.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var target = null
var acceleration = Vector2()
var is_staggered : bool = false


var is_frozen
var is_attacking : bool

# NOTE: Collision mask for the raycast2d is set to 8 since layer 8 is exclusive to the player/
func _ready():
	max_HP_calc = 50 + (Global.enemy_level_index * 10)
	level_calc = round(Global.enemy_level_index)
	max_HP = max_HP_calc
	HP = max_HP
	level = level_calc
	atk_value = 1 * Global.enemy_level_index
	MAX_SPEED = 3.5
	SPEED = MAX_SPEED
#	MAX_GRAVITY = 45
#	GRAVITY = MAX_GRAVITY
	phys_res = 0
	fire_res = -33.3
	earth_res = -33.3
	ice_res = -33.3
	global_res = 0
	weaknesses = ["Fire", "Ice", "Earth"]
	elemental_type = "Physical"
	debuff_damage_multiplier = 1
	$LevelLabel.text = "Lv " + str(level)
	$AnimatedSprite.play("Idle")
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value

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
		move_and_slide(velocity)
		
func _on_ProjectileAttackTimer_timeout():
	pass # Replace with function body.

func projectile_attack():
	if $ProjectileAttackCD.is_stopped() and !is_staggered and !is_near_player:
		$ProjectileAttackCD.start()
		var projectile = PROJECTILE.instance()
		projectile.atk_value = atk_value
		get_parent().add_child(projectile)
		projectile.position = global_position
func get_decoy():
	var decoy = get_parent().get_node("Decoy")
	return decoy
func get_player():
	var player = get_parent().get_node("Player")
	return player
func add_damage_particles(type : String, dmg : int, is_crit : bool = false):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.damage_type = type
	dmgparticle.damage_type = type
	dmgparticle.damage = dmg
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position

func parse_status_effect_damage():
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0:
		if Global.player_talents["SoulSiphon"]["unlocked"] and Global.player_talents["SoulSiphon"]["enabled"]:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var num = rng.randi_range(1,100)
			if num <= Global.player_talents["SoulSiphon"]["dropchance"]:
				var soul_orb = preload("res://scenes/skills/SoulOrb.tscn").instance()
				get_parent().add_child(soul_orb)
				soul_orb.position = global_position
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
						var damage = round(debuff_damage_multiplier * (raw_damage - (raw_damage * (phys_res / 100))))
						print("HP reduced by " + str(damage))
						HP -= float(damage)
						$HealthBar.value  -= float(damage)
						add_damage_particles("Physical", float(damage))
						parse_damage()
						break
		
		if area.is_in_group("SwordCharged"):
				var groups : Array = area.get_groups()
				for group_names in groups:
					if float(group_names) != 0:
						var raw_damage = float(group_names)
						
						var damage = debuff_damage_multiplier * (raw_damage - (raw_damage * (phys_res / 100)))
						print("HP reduced by " + str(damage))
						HP -= float(damage)
						$HealthBar.value  -= float(damage)
						if area.is_in_group("IsCritHit"):
							add_damage_particles("Physical", float(damage), true)
						else:
							add_damage_particles("Physical", float(damage), false)
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
#						print("HP reduced by " + str(groups.max()))
						HP -= debuff_damage_multiplier * float(groups.max())
					
						$HealthBar.value  -= debuff_damage_multiplier * float(groups.max())
						add_damage_particles("Fire", float(groups.max()))
						if area.is_in_group("LightKnockback"):
							parse_status_effect_damage()
						else:
							parse_damage()
						break
		if area.is_in_group("Ice"):
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0 and $HitDelayTimer.is_stopped():
					var raw_damage = float(group_names)
					var damage = round((raw_damage - (raw_damage * (ice_res / 100))))
					print("HP reduced by " + str(damage))
					HP -= debuff_damage_multiplier * float(damage)
					$HealthBar.value  -= debuff_damage_multiplier * float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Ice", float(damage), true)
					else:
						add_damage_particles("Ice", float(damage), false)
					$HitDelayTimer.start()
					parse_damage()
					break
		if area.is_in_group("Earth"):
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0:
					var raw_damage = float(group_names)
			
					var damage = round((raw_damage - (raw_damage * (earth_res / 100))))
					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
		
						add_damage_particles("Earth", float(damage), true)
					else:
						add_damage_particles("Earth", float(damage), false)
					
					parse_damage()
					break
		if area.is_in_group("FireGauge"):
			pass
		if area.is_in_group("Burning"):
			var groups : Array = area.get_groups()
			for group_names in groups:
				if $HitDelayTimer.is_stopped() and float(group_names) != 0:
					var raw_damage = float(group_names)
					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
					var damage = round((damage_after_global_res - (damage_after_global_res * (fire_res / 100))) * armor_strength_coefficient)
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					add_damage_particles("Fire", float(damage), false)
					$HitDelayTimer.start()
					parse_damage()
					break
		
		if area.is_in_group("Player"):
			is_staggered = true
			yield(get_tree().create_timer(0.5), "timeout")
			is_staggered = false

		if area.is_in_group("Frozen"):
				is_frozen = true
		
		if area.is_in_group("TempusTardus"):
			SPEED *= 0.1
			$AnimatedSprite.speed_scale = 0.1
			$ProjectileAttackTimer.stop()
		
		if area.is_in_group("LightPoiseDamage"):
			pass
		if area.is_in_group("MediumPoiseDamage"):
			pass
		if area.is_in_group("HeavyPoiseDamage"):
			pass

func parse_damage():
	if HP <= 0:
		drop_loot()
		drop_mana_bits(2)
		call_deferred('free')
func drop_loot():
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,6)
	if randomint == 1:
		get_parent().add_child(loot)
		loot.position = $Position2D.global_position
func drop_mana_bits(amount : int):
	var counter : int = 0
	while counter < amount:
		var mana_bit = preload("res://scenes/misc/ManaBits.tscn").instance()
		get_parent().add_child(mana_bit)
		mana_bit.position = global_position
		counter += 1

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






func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = 3.5
		$AnimatedSprite.speed_scale = 1.0
		$ProjectileAttackTimer.start()



func _on_Area2D2_area_entered(area):
	if area.is_in_group("Player"):
		is_near_player = true


func _on_Area2D2_area_exited(area):
	if area.is_in_group("Player"):
		
		is_near_player = false
