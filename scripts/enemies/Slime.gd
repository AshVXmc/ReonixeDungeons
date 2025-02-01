class_name Slime extends KinematicBody2D

var velocity : Vector2 = Vector2()
var max_HP : int = Global.enemy_level_index * 30 + 35
const AIRBORNE_SPEED : int = -4450
var level_calc : int = round(Global.enemy_level_index)
export var level : int = level_calc
var HP : int = max_HP
var is_dead : bool = false 
var direction : int = 1
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const MAX_SPEED : int = 100
var SPEED : int = MAX_SPEED
const MAX_GRAVITY : int = 45
var GRAVITY : int = MAX_GRAVITY
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
const DEATH_SMOKE : PackedScene = preload("res://scenes/particles/DeathSmokeParticle.tscn")
const FROZEN = preload("res://scenes/status_effects/FrozenStatus.tscn")
var is_frozen : bool = false
const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")
var is_staggered : bool = false
var is_airborne : bool
var elemental_type = "Physical"
var atk_value = 1 * Global.enemy_level_index
var phys_res : float = 25
var fire_res : float = 0
var earth_res : float = 0 
var ice_res : float = 0
var global_res : float = 0
var armor_strength_coefficient = 1
var debuff_damage_multiplier = 1
var damage_immunity : Dictionary = {
	fire = false,
	ice = false,
	earth = false,
	physical = false
}

func _ready():
	$LevelLabel.text = "Lv " + str(level)
	$HealthBar.max_value = max_HP
func _physics_process(delta):
	if !is_dead:
		if !is_airborne:
			set_collision_mask_bit(2, true)
			$AnimatedSprite.play("slimeanim")
		else:
			set_collision_mask_bit(2, false)
			$AnimatedSprite.stop()
	if !is_airborne:
		velocity.y += GRAVITY
		if direction == 1 and !is_dead:
			$AnimatedSprite.flip_h = false
		elif !is_dead:
			$AnimatedSprite.flip_h = true
	velocity = move_and_slide(velocity, FLOOR)
	if is_on_wall() or !$RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1
	if !is_dead and !is_frozen and !is_staggered and !is_airborne:
		velocity.x = SPEED * direction
		
		velocity.y += GRAVITY
	if 80 >= velocity.x and velocity.x >= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		if $Area2D.is_in_group("Hostile"):
			$Area2D.remove_from_group("Hostile") 
	else:
		yield(get_tree().create_timer(0.1), "timeout")
		if !$Area2D.is_in_group("Hostile"):
			$Area2D.add_to_group("Hostile")
		
	if is_staggered or is_frozen or is_airborne:
		velocity.x = 0
func _on_Area2D_area_entered(area):
	var groups_to_remove : Array = [
		"Sword", "SwordCharged", "Fireball", "Ice",
		"physics_process", "FireGauge", "FireGaugeTwo", "LightKnockback"
	]
	if !is_frozen:
		if is_airborne:
			if !area.is_in_group("NoAirborneKnockback") and area.is_in_group("LightPoiseDamage") or area.is_in_group("MediumPoiseDamage"):
				knockback(2.5)
		else:
			if area.is_in_group("LightPoiseDamage"):
				knockback(2.5)

		if area.is_in_group("MediumPoiseDamage"):
			knockback(12)
		if area.is_in_group("HeavyPoiseDamage"):
			knockback(25)
		if area.is_in_group("CustomPoiseDamage"):
			for g in area.get_groups():
				if float(g) != 0:
					knockback(float(g))

	if weakref(area).get_ref() != null:
		if area.is_in_group("Sword") and !damage_immunity.physical:
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0 and $HitDelayTimer.is_stopped():
					var raw_damage = float(group_names)
					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
					var damage = round(debuff_damage_multiplier * (damage_after_global_res - (damage_after_global_res * (phys_res / 100))) * armor_strength_coefficient)
					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Physical", float(damage), true)
					else:
						add_damage_particles("Physical", float(damage), false)
					$HitDelayTimer.start()
					parse_damage()
					break
					
		if area.is_in_group("SwordCharged") and !damage_immunity.physical:
				var groups : Array = area.get_groups()
				for group_names in groups:
					if float(group_names) != 0:
						var raw_damage = float(group_names)
						var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
						var damage = (debuff_damage_multiplier * (damage_after_global_res - (damage_after_global_res * (phys_res / 100))) * armor_strength_coefficient)
						print("HP reduced by " + str(damage))
						HP -= float(damage)
						$HealthBar.value  -= float(damage)
						if area.is_in_group("IsCritHit"):
							add_damage_particles("Physical", float(damage), true)
						else:
							add_damage_particles("Physical", float(damage), false)
						parse_damage()
						break
				
		if area.is_in_group("Fireball") and !damage_immunity.fire:
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0 and $HitDelayTimer.is_stopped():
					var raw_damage = float(group_names)
					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
					var damage = round(debuff_damage_multiplier * (damage_after_global_res - (damage_after_global_res * (fire_res / 100))) * armor_strength_coefficient)
					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Fire", float(damage), true)
					else:
						add_damage_particles("Fire", float(damage), false)
					$HitDelayTimer.start()
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
						parse_damage()
					break
		
		
		if area.is_in_group("Ice") and !damage_immunity.ice:
			print("ice entered")
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0 and $HitDelayTimer.is_stopped():
					var raw_damage = float(group_names)
					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
					var damage = round(debuff_damage_multiplier * (damage_after_global_res - (damage_after_global_res * (ice_res / 100))) * armor_strength_coefficient)
					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Ice", float(damage), true)
					else:
						add_damage_particles("Ice", float(damage), false)
					$HitDelayTimer.start()
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
						parse_damage()
					break
		if area.is_in_group("Earth") and !damage_immunity.earth:
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0 and $HitDelayTimer.is_stopped():
					var raw_damage = float(group_names)
					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
					var damage = round(debuff_damage_multiplier * (damage_after_global_res - (damage_after_global_res * (earth_res / 100))) * armor_strength_coefficient)
					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Earth", float(damage), true)
					else:
						add_damage_particles("Earth", float(damage), false)
					$HitDelayTimer.start()
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
						parse_damage()
					break
		if area.is_in_group("FireGauge"):
			pass
		if area.is_in_group("Burning") and !damage_immunity.fire:
			var groups : Array = area.get_groups()
			for group_names in groups:
				if $HitDelayTimer.is_stopped():
					var damage = debuff_damage_multiplier * max_HP * 0.08
#					print("AAAGH IT BURNS")
#					var raw_damage = float(group_names)
#					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
#					var damage = round((damage_after_global_res - (damage_after_global_res * (fire_res / 100))) * armor_strength_coefficient)
#					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Fire", float(damage), true)
					else:
						add_damage_particles("Fire", float(damage), false)
					$HitDelayTimer.start()
					parse_damage(false)
					break
		if area.is_in_group("Airborne") and !is_airborne:
			is_airborne = true
			velocity.y = 0
			velocity.y = AIRBORNE_SPEED
#			print(velocity.y)
			yield(get_tree().create_timer(0.05), "timeout")
			velocity.y = 0
		if area.is_in_group("Player"):
			is_staggered = true
			yield(get_tree().create_timer(0.5), "timeout")
			is_staggered = false

		if area.is_in_group("Frozen"):
			is_frozen = true
		
		if area.is_in_group("TempusTardus"):
			SPEED *= 0.05
			velocity.y = 0
			GRAVITY *= 0.05
			$AnimatedSprite.speed_scale = 0.1
		
		if is_airborne:
			if !area.is_in_group("NoAirborneKnockback") and area.is_in_group("LightPoiseDamage") or area.is_in_group("MediumPoiseDamage"):
				knockback(1)
		else:
			if area.is_in_group("LightPoiseDamage"):
				knockback(1)

		if area.is_in_group("MediumPoiseDamage"):
			knockback(3.5)
		if area.is_in_group("HeavyPoiseDamage"):
			knockback(10)
	
#	drop_loot()
func knockback(knockback_coefficient : float = 1):
	is_staggered = true
	if $AnimatedSprite.flip_h:
		velocity.x = SPEED * knockback_coefficient
	else:
		velocity.x = -SPEED * knockback_coefficient
	$HurtTimer.start()
	
	
func parse_damage(staggers:bool = true):
	if staggers:
		is_staggered = true
	$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
	$HurtTimer.start()
	if HP <= 0:
		drop_loot()
		death()
func parse_status_effect_damage():
	$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
	$HurtTimer.start()
	
func add_damage_particles(type : String, dmg : int, is_crit : bool):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.is_crit = is_crit
	dmgparticle.damage_type = type
	dmgparticle.damage = dmg
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position
	
func drop_loot():
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,2)
	if randomint == 1:
		get_parent().add_child(loot)
		loot.position = $Position2D.global_position

func death():
	is_dead = true
	$AnimatedSprite.stop()
	$AnimatedSprite.play("dead")
	$AnimationPlayer.play("Death")
	var deathparticle = DEATH_SMOKE.instance()
	deathparticle.emitting = true
	deathparticle.position = global_position
	get_parent().add_child(deathparticle)
	yield(get_tree().create_timer(0.3), "timeout")
	if Global.player_talents["SoulSiphon"]["unlocked"] and Global.player_talents["SoulSiphon"]["enabled"]:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var num = rng.randi_range(1,100)
		if num <= Global.player_talents["SoulSiphon"]["dropchance"]:
			var soul_orb = preload("res://scenes/skills/SoulOrb.tscn").instance()
			get_parent().add_child(soul_orb)
			soul_orb.position = global_position
	drop_mana_bits(2)
	call_deferred('free')
	Global.enemies_killed += 1
	

func drop_mana_bits(amount : int):
	var counter : int = 0
	while counter < amount:
		var mana_bit = preload("res://scenes/misc/ManaBits.tscn").instance()
		get_parent().add_child(mana_bit)
		mana_bit.position = global_position
		counter += 1
func _on_HurtTimer_timeout():
	is_staggered = false
	velocity.x = SPEED * direction
	$AnimatedSprite.set_modulate(Color(1,1,1,1))
	


func _on_Area2D_area_exited(area):
	if area.is_in_group("Frozen"):
		is_frozen = false
	if area.is_in_group("Airborne"):
		is_airborne = false
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED
		GRAVITY = MAX_GRAVITY
		$AnimatedSprite.speed_scale = 1.0
#		velocity.x = 0
