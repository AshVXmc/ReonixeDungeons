class_name Goblin extends BaseEnemy

const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const DEATH_SMOKE : PackedScene = preload("res://scenes/particles/DeathSmokeParticle.tscn")

export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1

const FLOOR = Vector2(0, -1)

var is_staggered : bool = false
var is_in_tempus_tardus : bool = false

# for witch goblin only (or golem?)
var is_casting : bool = false

# for masked goblin only
var is_casting_dash_attack : bool = false




const LOOT = preload("res://scenes/items/LootBag.tscn")
onready var AREA_LEFT : Area2D = $Left
onready var AREA_RIGHT : Area2D = $Right
onready var PLAYER = get_parent().get_node("Player/Area2D")
onready var DECOY = get_parent().get_node("Decoy/Area2D")
onready var DECOY2 = get_parent().get_node("Decoy2/Area2D")
onready var DECOY3 = get_parent().get_node("Decoy3/Area2D")
onready var GLOBAL_SKILL_CD = get_parent().get_node("EnemySkillGlobalCD")
var is_frozen : bool = false
var is_airborne : bool = false
var decoyed : bool = false
var dead : bool = false

const AIRBORNE_SPEED : int = -4000
export var Armored : bool = false

var previous_hit_id : String 


signal change_hitcount(amount)



signal on_death()

func _ready():
	max_HP_calc = 50 + (Global.enemy_level_index * 16)
	level_calc = round(Global.enemy_level_index)
	max_HP = max_HP_calc
	HP = max_HP
	level = level_calc
	atk_value = 2.25 * Global.enemy_level_index + 1
	MAX_SPEED = 125
	SPEED = MAX_SPEED
	MAX_GRAVITY = 45
	GRAVITY = MAX_GRAVITY
	phys_res = -33.3
	fire_res = -33.3
	earth_res = 0
	ice_res = 0
	global_res = 0
	weaknesses = ["Physical", "Fire"]
	elemental_type = "Physical"
	debuff_damage_multiplier = 1
	
	$LevelLabel.text = "Lv " + str(level)
	if self.name == "Goblin":
		$SpearThrustAttackWarning.visible = false
	if Armored:
		$ArmorBar.visible = true
		$ArmorBar.max_value = Armor_Durability
		$ArmorSprite.visible = true
		armor_strength_coefficient = 1 - Armor_Strength
		add_to_group("Armored")
	else:
		$ArmorBar.visible = false
		$ArmorSprite.visible = false
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value
	connect("change_hitcount", get_parent().get_node("EleganceMeterUI/Control"), "hitcount_changed")





func _physics_process(delta):
	if !is_airborne:
		set_collision_mask_bit(2, true)
	else:
		set_collision_mask_bit(2, false)
	if flipped:
		$Sprite.flip_h = true
	if !is_airborne:
		velocity.y += GRAVITY
	if !is_casting_dash_attack:
		velocity = move_and_slide(velocity, FLOOR)
	if !$Sprite.flip_h:
		$OtherEnemyDetector.set_scale(Vector2(1,1))
		$SpearThrustAttackCollision.set_scale(Vector2(1,1))
	else:
		$OtherEnemyDetector.set_scale(Vector2(-1,1))
		$SpearThrustAttackCollision.set_scale(Vector2(-1,1))
	
	if (MAX_SPEED * 0.6) >= velocity.x and velocity.x >= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		if !is_casting:
			$Sprite.play("Idle")
		if $Area2D.is_in_group("Hostile"):
			$Area2D.remove_from_group("Hostile") 
	else:
		yield(get_tree().create_timer(0.1), "timeout")
		if !is_casting:
			$Sprite.play("Attacking")
		if !$Area2D.is_in_group("Hostile"):
			$Area2D.add_to_group("Hostile")
	if is_on_floor() and !is_casting and !is_casting_dash_attack:
		if !is_staggered and !$Area2D.overlaps_area(PLAYER) and !other_enemy_detector_is_overlapping_player() and !is_frozen and !dead and !is_airborne and weakref(PLAYER).get_ref() != null: 
			if AREA_LEFT.overlaps_area(PLAYER) and !AREA_LEFT.overlaps_area(DECOY) and !AREA_LEFT.overlaps_area(DECOY2) and !AREA_LEFT.overlaps_area(DECOY3):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = -SPEED
			elif AREA_LEFT.overlaps_area(DECOY) or AREA_LEFT.overlaps_area(DECOY2) or AREA_LEFT.overlaps_area(DECOY):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = -SPEED 
			if AREA_RIGHT.overlaps_area(PLAYER) and !AREA_RIGHT.overlaps_area(DECOY) and !AREA_RIGHT.overlaps_area(DECOY2) and !AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = SPEED 
			elif AREA_RIGHT.overlaps_area(DECOY) or AREA_RIGHT.overlaps_area(DECOY2) or AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = SPEED
	if other_enemy_is_on_front() and !is_casting:
		velocity.x = 0
		
	if !is_casting and $Area2D.overlaps_area(PLAYER) or other_enemy_is_on_front() and !is_staggered:

		if $Sprite.flip_h:
			velocity.x = -SPEED * 1
		else:
			velocity.x = SPEED * 1
	if other_enemy_detectors_is_overlapping():
		if $Sprite.flip_h:
			velocity.x = -SPEED 
		else:
			velocity.x = SPEED 
	if other_enemy_is_on_front():
		if other_enemy_detector_is_overlapping_player():
			if $Sprite.flip_h:
				velocity.x = -SPEED 
			else:
				velocity.x = SPEED
		elif AREA_LEFT.overlaps_area(PLAYER) or AREA_RIGHT.overlaps_area(PLAYER):
			if $Sprite.flip_h:
				velocity.x = -SPEED 
			else:
				velocity.x = SPEED
	if is_staggered or is_frozen or is_airborne:
		velocity.x = 0


func spear_thrust_attack():
	$SpearThrustAttackCollision.add_to_group(str(atk_value))

func drop_mana_bits(amount : int):
	var counter : int = 0
	while counter < amount:
		var mana_bit = preload("res://scenes/misc/ManaBits.tscn").instance()
		get_parent().add_child(mana_bit)
		mana_bit.position = global_position
		counter += 1

func other_enemy_detector_is_overlapping_player():
	var bodies = $OtherEnemyDetector.get_overlapping_bodies()
	if bodies.empty():
		return null
	for b in bodies:
		if b.is_in_group("PlayerEntity"):
			return true
		else:
			return false
func other_enemy_is_on_front():
	var bodies = $OtherEnemyDetector.get_overlapping_bodies()
	if bodies.empty():
		return null
	for b in bodies:
		if b.is_in_group("EnemyEntity") and !b.is_staggered:
			return true
		else:
			return false
func other_enemy_detectors_is_overlapping():
	var areas = $OtherEnemyDetector.get_overlapping_areas()
	if areas.empty():
		return null
	for a in areas:
		if a.is_in_group("OtherEnemyDetector"):
			return true


func _on_Area2D_area_entered(area):
	var groups_to_remove : Array = [
		"Sword", "SwordCharged", "Fireball", "Ice",
		"physics_process", "FireGauge", "FireGaugeTwo", "LightKnockback"
	]
	if !is_frozen:
		if is_airborne:
			if !area.is_in_group("NoAirborneKnockback") and area.is_in_group("LightPoiseDamage") or area.is_in_group("MediumPoiseDamage"):
				knockback(1.5)
		else:
			if area.is_in_group("LightPoiseDamage"):
				knockback(2)

		if area.is_in_group("MediumPoiseDamage"):
			knockback(12)
		if area.is_in_group("HeavyPoiseDamage"):
			knockback(20)
		if area.is_in_group("ExtremePoiseDamage"):
			knockback(36)
		if area.is_in_group("CustomPoiseDamage"):
			for g in area.get_groups():
				if float(g) != 0:
					knockback(float(g))
	if weakref(area).get_ref() != null:
		if area.is_in_group("Sword"):
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0 and $HitDelayTimer.is_stopped():
					var raw_damage = float(group_names)
					var damage_after_global_res = raw_damage - (raw_damage * (global_res / 100))
					var damage = round(debuff_damage_multiplier * (damage_after_global_res - (damage_after_global_res * (phys_res / 100))) * armor_strength_coefficient)
#					print("HP reduced by " + str(damage))
					HP -= float(damage)
					$HealthBar.value  -= float(damage)
					if area.is_in_group("IsCritHit"):
						
						add_damage_particles("Physical", float(damage), true)
					else:
						add_damage_particles("Physical", float(damage), false)
					$HitDelayTimer.start()
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
						parse_damage()
					break
					
		if area.is_in_group("SwordCharged"):
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
				
		if area.is_in_group("Fireball"):
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0:
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
					
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
						parse_damage()
					break
		
		
		if area.is_in_group("Ice"):
			print("ice entered")
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0:
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
					
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
						parse_damage()
					break
		
		if area.is_in_group("Earth"):
			var groups : Array = area.get_groups()
			for group_names in groups:
				if float(group_names) != 0:
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
					if area.is_in_group("NoStagger"):
						parse_damage(false)
					else:
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
					parse_damage(false)
					break
		if area.is_in_group("Airborne") and !is_airborne:
			is_airborne = true
			velocity.y = AIRBORNE_SPEED
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
			$Sprite.speed_scale = 0.1
			is_in_tempus_tardus = true
		
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
	
		if area.is_in_group("EnemyHealingOrb") and self.is_in_group("CanBeHealed") and HP < max_HP:
			heal(0.2)

func add_damage_particles(type : String, dmg : int, is_crit : bool):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.is_crit = is_crit
	dmgparticle.damage_type = type
	dmgparticle.damage = round(dmg)
	
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position

func heal(amount : float):
	# amount = percent of max health that gets healed. (Float)
	HP = clamp(HP + (max_HP * amount), 0, max_HP)
	$HealthBar.value = HP
	
func knockback(knockback_coefficient : float = 1):
	is_staggered = true
	if $Sprite.flip_h:
		velocity.x = -SPEED * knockback_coefficient
	else:
		velocity.x = SPEED * knockback_coefficient
	$HurtTimer.start()
func armor_break():
	pass
func parse_damage(staggers : bool = true):
	if staggers:
		is_staggered = true
	emit_signal("change_hitcount", 1)
	$Sprite.set_modulate(Color(1.4,0.5,0.3,1))
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0 and !dead:
		start_death_sequence()

func start_death_sequence():
	dead = true
	$Area2D/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$Left/CollisionShape2D.disabled = true
	$Right/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Death")

func death():
	$Sprite.visible = false
	$Area2D.remove_from_group("Hostile")
	var deathparticle = DEATH_SMOKE.instance()
	deathparticle.emitting = true
	deathparticle.position = global_position
	get_parent().add_child(deathparticle)
	
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,3)
	if randomint == 1:
		get_parent().add_child(loot)
		loot.opals_amount = 25
		loot.position = $Position2D.global_position
	
	if Global.player_talents["SoulSiphon"]["unlocked"] and Global.player_talents["SoulSiphon"]["enabled"]:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var num = rng.randi_range(1,100)
		if num <= Global.player_talents["SoulSiphon"]["dropchance"]:
			var soul_orb = preload("res://scenes/skills/SoulOrb.tscn").instance()
			get_parent().add_child(soul_orb)
			soul_orb.position = global_position
	drop_mana_bits(3)
	call_deferred('free')
	print("reached")
	Global.enemies_killed += 1
func parse_status_effect_damage():
	$Sprite.set_modulate(Color(1.4,0.5,0.3,1))
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0 and !dead:
		start_death_sequence()
		
func _on_HurtTimer_timeout():
	is_staggered = false
	$Sprite.set_modulate(Color(1,1,1,1))

func _on_AttackingTimer_timeout():
	velocity.x = 0



func _on_Left_area_exited(area):
	yield(get_tree().create_timer(2), "timeout")
	velocity.x = 0


func _on_Right_area_exited(area):
	
	yield(get_tree().create_timer(2), "timeout")
	velocity.x = 0


func _on_Area2D_area_exited(area):

	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED
		GRAVITY = MAX_GRAVITY
		$Sprite.speed_scale = 1.0
		is_in_tempus_tardus = false
	if area.is_in_group("Frozen"):
		is_frozen = false
	if area.is_in_group("Airborne"):
		is_airborne = false
		velocity.x = 0

#
#func _on_Area2D_body_entered(body):
#	if body.is_in_group("Enemy"):
#		set_collision_mask_bit(2, false)
#
#
#func _on_Area2D_body_exited(body):
#	if body.is_in_group("Enemy"):
#		set_collision_mask_bit(2, true)

#
func _on_DownwardsEnemyDetector_area_entered(area):
	if area.is_in_group("Enemy"):
		set_collision_mask_bit(2, false)

func _on_DownwardsEnemyDetector_area_exited(area):
	if area.is_in_group("Enemy"):
		set_collision_mask_bit(2, true)


func _on_Goblin_tree_exiting():
	emit_signal("on_death")

