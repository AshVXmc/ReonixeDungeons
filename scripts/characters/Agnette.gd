class_name Agnette extends Node2D

const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
const TEMPUS_TARGUS : PackedScene = preload("res://scenes/misc/TempusTardus.tscn")
const HEAL_PARTICLE : PackedScene = preload("res://scenes/particles/HealIndicatorParticle.tscn")
const ARROW = preload("res://scenes/skills/AgnetteArrow.tscn")
signal skill_used(skill_name)
signal mana_changed(amount, character)
signal life_changed(amount, character)
signal healthpot_obtained(player_healthpot)
signal attack_buff(amount, duration)
signal perfect_dash()
signal action(action_type)
signal trigger_quickswap(trigger_name)
signal ready_to_be_switched_in(character)
signal change_elegance(action_name)
signal change_hitcount(amount)
var target
var is_
var airborne_mode : bool = false
var basicatkbuffmulti : float = 0
var basicatkbuffdur : float = 0
var is_performing_charged_attack : bool
var attack_area_overlaps_enemy : bool 
# Attack buff for BASIC ATTACKS ONLY.
var atkbuffmulti = 0
var atkbuffdur = 0
# Attack buff for all abilities (Skills)
var atkbuffskill = 0
# Permanent dmg bonus. Stacks additively with ice_dmg_bonus. 12% DMG bonus per sigil

var buffed_from_attack_crystals = false
var buffed_from_damage_bonus_crystals = false
var prev_phys_dmg_bonus : Array 
var prev_fire_dmg_bonus : Array 
var prev_ice_dmg_bonus : Array 
var prev_earth_dmg_bonus : Array 
var number_of_phys_dmg_bonus_buffs : int
var number_of_fire_dmg_bonus_buffs : int
var number_of_ice_dmg_bonus_buffs : int
var number_of_earth_dmg_bonus_buffs : int

var prev_attack_power : Array
var number_of_atk_buffs : int = 0
var attack_string_count : int = 4
var restore_mana_for_all_parties : int = 2
var buffed_attack_power : float
var is_charging = false

var attack_collsion_overlaps_enemy : bool = false
var number_of_basic_atk_buffs : int
var basic_attack_buff : float
var prev_basic_attack_power : Array
var attack_buff : float
var is_dead: bool = false
var ATTACK = Global.glaciela_attack
var phys_res : float = Global.glaciela_skill_multipliers["BasePhysRes"]
var fire_res : float = Global.glaciela_skill_multipliers["BaseFireRes"]
var ice_res : float = Global.glaciela_skill_multipliers["BaseIceRes"]
var earth_res : float = Global.glaciela_skill_multipliers["BaseEarthRes"]
var phys_dmg_bonus : float = Global.glaciela_skill_multipliers["PhysDamageBonus"]
var fire_dmg_bonus : float = Global.glaciela_skill_multipliers["FireDamageBonus"]
var ice_dmg_bonus : float = Global.glaciela_skill_multipliers["IceDamageBonus"]
var earth_dmg_bonus : float = Global.glaciela_skill_multipliers["EarthDamageBonus"]

onready var crit_rate : float = Global.glaciela_skill_multipliers["CritRate"]
onready var crit_damage : float = Global.glaciela_skill_multipliers["CritDamage"]
onready var pskill_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("SkillsUI/Control/PrimarySkill/Agnette/BearForm/TextureProgress")
#onready var sskill_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("SkillsUI/Control/SecondarySkill/Glaciela/IceLance/TextureProgress")
#onready var tskill_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("SkillsUI/Control/TertiarySkill/Glaciela/ConeOfCold/TextureProgress")


var current_form = forms.ARCHER
enum forms  {
	ARCHER, BEAR
}

func _ready():
#	print(get_path())
	
	if Global.equipped_characters.has("Player"):
		connect("trigger_quickswap", get_parent().get_parent(), "quickswap_event")


	connect("action", Global, "parse_action")
	connect("change_elegance", get_parent().get_parent().get_parent().get_node("EleganceMeterUI/Control"), "elegance_changed")
	connect("change_hitcount", get_parent().get_parent().get_parent().get_node("EleganceMeterUI/Control"), "hitcount_changed")
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
	connect("healthpot_obtained", Global, "sync_playerHealthpots")
	emit_signal("healthpot_obtained", Global.healthpot_amount)
	connect("life_changed", Global, "sync_hearts")
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	connect("perfect_dash",  get_parent().get_parent().get_parent().get_node("PauseUI/PerfectDash"), "trigger_perfect_dash_animation")
	connect("life_changed", get_parent().get_parent().get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	connect("mana_changed", get_parent().get_parent().get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
#	connect("skill_used", get_parent().get_parent().get_parent().get_node("SkillsUI/Control"), "on_skill_used")
	connect("skill_used", get_parent().get_parent().get_node("SkillManager"), "on_skill_used")
	$StrongJumpParticle.visible = false
	play_animated_sprite("Default")
	$BearFormDurationTimer.wait_time = Global.agnette_skill_multipliers["BearFormDuration"]
	
#	$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack1_1"] / 100)))


func _physics_process(delta):
	target = get_closest_enemy()
	if !$AnimatedSprite.flip_h:
		$EnemyEvasionArea.set_scale(Vector2(1,1))
	else:
		$EnemyEvasionArea.set_scale(Vector2(-1,1))
	
	if is_charging and Global.current_character != "Agnette":
		toggle_charged_attack_snare(false)
		is_charging = false
		$ChargedAttackBarFillTimer.stop()
		$ChargedAttackBar.value = $ChargedAttackBar.min_value
		
	if Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
		Input.action_release("left")
		$AnimatedSprite.flip_h = false
		play_animated_sprite("Walk")
		
#		attack_string_count = 4
	elif Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
		Input.action_release("right")
		$AnimatedSprite.flip_h = true
		play_animated_sprite("Walk")
		
#		attack_string_count = 4
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") and attack_string_count != 3:
		attack_string_count = 4
	if Global.current_character == "Agnette":
#		charge_meter()
		$AnimatedSprite.visible = true

		if get_parent().get_parent().velocity.x == 0:
			play_animated_sprite("Default")
		
		if get_parent().get_parent().can_dash:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right") and !Input.is_action_pressed("jump"):
				play_animated_sprite("Walk")
			else:
				play_animated_sprite("Default")

		if current_form == forms.ARCHER:
			if Input.is_action_just_pressed("ui_dash") and !get_parent().get_parent().can_dash and !get_parent().get_parent().get_node("DashUseTimer").is_stopped():
				$AnimatedSprite.play("Dash")
				
				print("text")
	#			attack_string_count = 4
				yield(get_tree().create_timer(0.25), "timeout")
				play_animated_sprite("Default")
			if Input.is_action_just_pressed("jump"):
				attack_string_count = 4
				play_animated_sprite("Default")
			if !$AnimatedSprite.flip_h:
				$BowSprite.flip_h = true
				$BowSprite.position.x = 40
			else:
				$BowSprite.flip_h = false
				$BowSprite.position.x = -40
		if current_form == forms.BEAR:
			if !$AnimatedSprite.flip_h:
				$BearFormNodes/AttackCollision.position.x = 100
			else:
				$BearFormNodes/AttackCollision.position.x = -100
		use_skill()
#		print(is_charging)

			
#		if Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill"):
#			print("skill emitted")
#			emit_signal("skill_used", "IceLance")

func play_animated_sprite(anim_name : String):
	match anim_name:
		"Default":
			if current_form == forms.ARCHER:
				$AnimatedSprite.play("Default")
			elif current_form == forms.BEAR:
				$AnimatedSprite.play("BearDefault")
		"Walk":
			if current_form == forms.ARCHER:
				$AnimatedSprite.play("Walk")
			elif current_form == forms.BEAR:
				$AnimatedSprite.play("BearWalk")



func _input(event):
	if Global.current_character == "Agnette":
		if current_form == forms.ARCHER and event.is_action_pressed("ui_attack") and !is_charging:
			attack()
			$InputPressTimer.start()
			
		
		if event.is_action_pressed("heal"):
			if Global.healthpot_amount > 0:
				heal(5)
		if event.is_action_pressed("ui_dash") and $DashInputPressTimer.is_stopped():
			print("awooga")
			get_parent().get_parent().dash()
			$DashInputPressTimer.start()
	
		# CHARGED ATTACK
		if event.is_action_released("ui_attack"):
			if is_charging:
				toggle_charged_attack_snare(false)
			
			is_charging = false
			if current_form == forms.ARCHER:
				charged_attack()
			
			$ChargedAttackBarFillTimer.stop()
			$ChargedAttackBar.value = $ChargedAttackBar.min_value
			$BowAnimationPlayer.play("BowAttackRight")


func use_skill():
	if Global.current_character == "Agnette" and !get_parent().get_parent().is_frozen:
		if pskill_ui.value >= pskill_ui.max_value and Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill"): 
			use_primary_skill()
#		if sskill_ui.value >= sskill_ui.max_value and Input.is_action_just_pressed("secondary_skill") and !Input.is_action_just_pressed("primary_skill"):
#			use_secondary_skill()
#		if tskill_ui.value >= tskill_ui.max_value and Input.is_action_just_pressed("tertiary_skill"):
#			use_tertiary_skill()

func use_primary_skill():
	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.agnette_skill_multipliers["BearFormCost"]:
		emit_signal("skill_used", "BearForm", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "BearForm")
		emit_signal("mana_changed", Global.mana, "Agnette")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.agnette_skill_multipliers["BearFormCost"]:
		emit_signal("skill_used", "BearForm", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "BearForm")
		emit_signal("mana_changed", Global.character2_mana, "Agnette")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.agnette_skill_multipliers["BearFormCost"]:
		emit_signal("skill_used", "BearForm", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "BearForm")
		emit_signal("mana_changed", Global.character3_mana, "Agnette")
	
func use_secondary_skill():
	pass

func use_tertiary_skill():
	pass


func wild_shape(target_form : int, with_particles : bool = true):
	current_form = target_form
	if with_particles:
		$WildShapeParticles.emitting = true
	match target_form:
		forms.ARCHER:
			$ChargedAttackBar.visible = true
			get_parent().get_parent().mobility_lock = false
			$BearFormNodes/BearHealthBar.visible = false
			$BowSprite.visible = true
		forms.BEAR:
			$ChargedAttackBar.visible = false
			get_parent().get_parent().mobility_lock = true
			$BearFormNodes/BearHealthBar.max_value = Global.character_health_data["Agnette"] * (Global.agnette_skill_multipliers["BearFormHealth"] / 100)
			print("bear HP: " + str($BearFormNodes/BearHealthBar.max_value))
			$BearFormNodes/BearHealthBar.value = $BearFormNodes/BearHealthBar.max_value
			$BearFormNodes/BearHealthBar.visible = true
			$BowSprite.visible = false
			
			


func toggle_charged_attack_snare(active : bool):
	if active:
		$SelfSnareArea.remove_from_group("AgnetteChargedAttackSnareOff")
		$SelfSnareArea.add_to_group("AgnetteChargedAttackSnareOn")
		$SelfSnareArea/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(0.1), "timeout")
		$SelfSnareArea/CollisionShape2D.disabled = true
	else:
		$SelfSnareArea.remove_from_group("AgnetteChargedAttackSnareOn")
		$SelfSnareArea.add_to_group("AgnetteChargedAttackSnareOff")
		$SelfSnareArea/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(0.1), "timeout")
		$SelfSnareArea/CollisionShape2D.disabled = true

func charged_attack():
	# the arrow deals earth damage and builds earth trauma
	if $ShootTimer.is_stopped():
		if $ChargedAttackBar.value >= $ChargedAttackBar.max_value / 2:
			spawn_arrow($ChargedAttackBar.value, true)
			attack_string_count = 4
		else:
			spawn_arrow($ChargedAttackBar.value)
		$ShootTimer.start()

func charged_dash():
	$DashInputPressTimer.stop()
func attack():
	if Global.current_character == "Agnette" and $ShootTimer.is_stopped():
#		if get_parent().get_parent().is_on_floor():
		airborne_mode = true
		$AirborneTimer.start()
		$BowAnimationPlayer.play("BowAttackRight")
		spawn_arrow()
		$ResetAttackStringTimer.stop()

		$ShootTimer.start()
		
		$ResetAttackStringTimer.start()
func spawn_arrow(charge_value : int = 0, earth_damage : bool = false):
	var charged_bonus : float = 1 + (2.5 * charge_value / 100)
#	print("charge value: " + str(charge_value))
	if charge_value >= 50:
		charged_bonus = 1 + (5.25 * charge_value / 100)

	var crit_dmg : float = 1.0
	var arrow = ARROW.instance()
	
	get_parent().get_parent().get_parent().add_child(arrow)
	if earth_damage:
		arrow.get_node("Area2D").remove_from_group("Sword")
		arrow.get_node("Area2D").add_to_group("Earth")
	if is_a_critical_hit():
		crit_dmg = (Global.agnette_skill_multipliers["CritDamage"] / 100 + 1)
		arrow.get_node("Area2D").add_to_group("IsCritHit")
	else:
		arrow.get_node("Area2D").remove_from_group("IsCritHit")
	
	var mult : int = 4 - attack_string_count + 1
	arrow.get_node("Area2D").add_to_group(str(charged_bonus * Global.agnette_attack * (Global.agnette_skill_multipliers["Arrow" + str(mult)] / 100) * crit_dmg))
	
	if !$AnimatedSprite.flip_h:
		arrow.position.x = global_position.x + 40
		arrow.position.y = global_position.y
	else:
		arrow.position.x = global_position.x - 40
		arrow.position.y = global_position.y
		arrow.x_direction = -1
	print("atk string: " + str(attack_string_count))
	attack_string_count -= 1
	attack_string_count = clamp(attack_string_count, 0, 4)
	if attack_string_count == 0:
		attack_string_count = 4
func play_attack_animation():
	pass

func is_a_critical_hit() -> bool:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(0 ,100)
	if num <= Global.agnette_skill_multipliers["CritRate"]:
		return true
	else:
		return false
		

func change_mana_value(amount : float):
	if Global.current_character == Global.equipped_characters[0] and Global.mana < Global.max_mana:
		Global.mana += amount
		emit_signal("mana_changed", Global.mana, "Agnette")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana < Global.character2_max_mana:
		Global.character2_mana += amount
		emit_signal("mana_changed", Global.character2_mana, "Agnette")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana < Global.character3_max_mana:
		Global.character3_mana += amount
		emit_signal("mana_changed", Global.character3_mana, "Agnette")
func add_heal_particles(heal_amount : float):
	var heal_particle = HEAL_PARTICLE.instance()
	heal_particle.heal_amount = heal_amount * 2
	get_parent().get_parent().get_parent().add_child(heal_particle)
	heal_particle.position = global_position
func heal(heal_amount : float):
	# heal amount in percentage based on max HP
	if Global.equipped_characters[0] == "Agnette":
		add_heal_particles(clamp(heal_amount, 0, Global.max_hearts - Global.hearts))
		Global.hearts += clamp(heal_amount, 0, Global.max_hearts - Global.hearts)
		emit_signal("life_changed", Global.hearts, "Agnette")
	elif Global.equipped_characters[1] == "Agnette":
		add_heal_particles(clamp(heal_amount, 0, Global.character_2_max_hearts - Global.character2_hearts))
		Global.character2_hearts += clamp(heal_amount, 0, Global.character_2_max_hearts - Global.character2_hearts)
		emit_signal("life_changed", Global.character2_hearts, "Agnette")
		print("healed")
	elif Global.equipped_characters[2] == "Agnette":
		add_heal_particles(clamp(heal_amount, 0, Global.character_3_max_hearts - Global.character3_hearts))
		Global.character3_hearts += clamp(heal_amount, 0, Global.character_3_max_hearts - Global.character3_hearts)
		emit_signal("life_changed", Global.character3_hearts, "Agnette")
	Global.healthpot_amount -= 1
	emit_signal("healthpot_obtained", Global.healthpot_amount)
	






func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = get_parent().get_parent().global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy
	

# HOW ATTACK BUFFS WORK
# If active character gets into contact with an area with the group "Attackbuffmultiplier
# Do the thing where it iterates for a number which is the multiplier
# If active character gets into contact with an area with the group "Attackbufftimer"
# Do the thing where it iterates for a number which is the multiplier

func set_basic_attack_power(amount : float, duration : float, show_particles : bool = true):
	# DONT ASK THIS IS SO COMPLICATED ON GODDDD
		buffed_from_attack_crystals = true
		number_of_basic_atk_buffs += 1
		prev_basic_attack_power.insert((number_of_basic_atk_buffs - 1), basic_attack_buff) 
		basic_attack_buff = prev_basic_attack_power[number_of_basic_atk_buffs - 1] + amount
		yield(get_tree().create_timer(duration), "timeout")
		basic_attack_buff = prev_basic_attack_power[number_of_basic_atk_buffs - 1]
		number_of_basic_atk_buffs -= 1
		prev_basic_attack_power.remove(number_of_basic_atk_buffs)

		buffed_from_attack_crystals = false


func set_damage_bonus(amount : float, duration : float, show_particles : bool , type : String):
	buffed_from_damage_bonus_crystals = true
	var other_groups : Array
	match type:
		"Physical":
			number_of_phys_dmg_bonus_buffs += 1
			prev_phys_dmg_bonus.insert((number_of_phys_dmg_bonus_buffs - 1), phys_dmg_bonus)
			phys_dmg_bonus =  prev_phys_dmg_bonus[number_of_phys_dmg_bonus_buffs- 1] + amount
			yield(get_tree().create_timer(duration), "timeout")
			phys_dmg_bonus =  prev_phys_dmg_bonus[number_of_phys_dmg_bonus_buffs- 1]
			number_of_phys_dmg_bonus_buffs -= 1
			prev_phys_dmg_bonus.remove(number_of_phys_dmg_bonus_buffs)
			buffed_from_damage_bonus_crystals = false
		"Fire":
			number_of_fire_dmg_bonus_buffs += 1
			prev_fire_dmg_bonus.insert((number_of_fire_dmg_bonus_buffs - 1), fire_dmg_bonus)
			fire_dmg_bonus =  prev_fire_dmg_bonus[number_of_fire_dmg_bonus_buffs- 1] + amount
			yield(get_tree().create_timer(duration), "timeout")
			fire_dmg_bonus =  prev_fire_dmg_bonus[number_of_fire_dmg_bonus_buffs- 1]
			number_of_fire_dmg_bonus_buffs -= 1
			prev_fire_dmg_bonus.remove(number_of_fire_dmg_bonus_buffs)
			buffed_from_damage_bonus_crystals = false
		"Ice":
			number_of_ice_dmg_bonus_buffs += 1
			prev_ice_dmg_bonus.insert((number_of_ice_dmg_bonus_buffs - 1), ice_dmg_bonus)
			ice_dmg_bonus =  prev_ice_dmg_bonus[number_of_ice_dmg_bonus_buffs- 1] + amount
			yield(get_tree().create_timer(duration), "timeout")
			ice_dmg_bonus =  prev_ice_dmg_bonus[number_of_ice_dmg_bonus_buffs- 1]
			number_of_ice_dmg_bonus_buffs -= 1
			prev_ice_dmg_bonus.remove(number_of_ice_dmg_bonus_buffs)
			buffed_from_damage_bonus_crystals = false
		"Earth":
			number_of_earth_dmg_bonus_buffs += 1
			prev_earth_dmg_bonus.insert((number_of_earth_dmg_bonus_buffs - 1), earth_dmg_bonus)
			earth_dmg_bonus =  prev_earth_dmg_bonus[number_of_earth_dmg_bonus_buffs- 1] + amount
			yield(get_tree().create_timer(duration), "timeout")
			earth_dmg_bonus =  prev_earth_dmg_bonus[number_of_earth_dmg_bonus_buffs- 1] 
			number_of_earth_dmg_bonus_buffs -= 1
			prev_earth_dmg_bonus.remove(number_of_earth_dmg_bonus_buffs)
			buffed_from_damage_bonus_crystals = false
		



func set_attack_power(amount : float, duration : float, show_particles : bool = true):
	buffed_from_attack_crystals = true
	number_of_atk_buffs += 1
	
	var other_groups : Array
	prev_attack_power.insert((number_of_atk_buffs - 1), attack_buff) 
	print(prev_attack_power)
	attack_buff = prev_attack_power[number_of_atk_buffs - 1] + amount
	
	print("Buffed: " + str(attack_buff))
	yield(get_tree().create_timer(duration), "timeout")
	attack_buff = prev_attack_power[number_of_atk_buffs - 1]
	print("DeBuffed: " + str(prev_attack_power[number_of_atk_buffs - 1]))
	number_of_atk_buffs -= 1
	prev_attack_power.remove(number_of_atk_buffs)
	buffed_from_attack_crystals = false
	





func _on_Area2D_area_entered(area):
	if area.is_in_group("AgnetteChargedAttackSnareOn"):
		var slowdown_coefficient : float = Global.agnette_skill_multipliers["ChargedAttackMovementSpeedPenalty"] / 100
		get_parent().get_parent().SPEED -= get_parent().get_parent().MAX_SPEED * slowdown_coefficient
	if area.is_in_group("AgnetteChargedAttackSnareOff"):
		var slowdown_coefficient : float = Global.agnette_skill_multipliers["ChargedAttackMovementSpeedPenalty"] / 100
		get_parent().get_parent().SPEED += get_parent().get_parent().MAX_SPEED * slowdown_coefficient
	if Global.current_character == "Agnette":
		if area.is_in_group("HealthPot"):
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		if area.is_in_group("LifeWine"):
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		
		if !Global.godmode:
			if $InvulnerabilityTimer.is_stopped() and !get_parent().get_parent().is_invulnerable and !get_parent().get_parent().is_dashing:
				if area.is_in_group("Enemy") and area.is_in_group("Hostile") or area.is_in_group("Projectile"):
#					print("GLACIELA HURT")
					match area.get_parent().elemental_type:
						"Physical":
							var dmg = area.get_parent().atk_value
							take_damage(dmg * (1 - phys_res))
#					get_parent().get_parent().is_invulnerable = true
					get_parent().get_parent().is_gliding = false
					Input.action_release("charge")
					Input.action_release("ui_attack")
					after_damaged()
					if !area.is_in_group("LightEnemy") or !get_parent().get_parent().resist_interruption:
						get_parent().get_parent().knockback()
						
#				if area.is_in_group("Enemy2"):
#					take_damage(2)
#					add_hurt_particles(1)
#					is_gliding = false
#					Input.action_release("charge")
#					afterDamaged()
#					knockback()
#					$CampfireTimer.stop()
			if area.is_in_group("Spike"):
				Input.action_release("charge")
				after_damaged()
		if area.is_in_group("SlowingPoison"):
			get_parent().get_parent().slow_player(2.0)
		if area.is_in_group("Transporter"):
			get_parent().get_parent().emit_signal("level_changed")
		if area.is_in_group("BasicAttackBuff"):
			basicatkbuffmulti = area.amount
			basicatkbuffdur = area.duration
			set_basic_attack_power(float(basicatkbuffmulti), float(basicatkbuffdur))
			print("STRONK")
		if area.is_in_group("DamageBonusBuff"):
			set_damage_bonus(float(area.amount), float(area.duration), true, area.type)
			
#	if area.is_in_group("Enemy") and !get_parent().get_parent().is_invulnerable:
#		$AnimationPlayer.play("Hurt")
func after_damaged():
	get_parent().get_parent().inv_timer.start() 
	get_parent().get_parent().is_invulnerable = true
	$InvulnerabilityTimer.start()
	
#	emit_signal("life_changed", Global.hearts)
#	$Sprite.play("Hurt")
	if !Global.godmode:
		get_parent().get_parent().get_node("KnockbackTimer").start()
		
	if Global.equipped_characters[0] == Global.current_character:
		if Global.hearts <= 0:
			dead(Global.equipped_characters[0])
	elif Global.equipped_characters[1] == Global.current_character:
		if Global.hearts <= 0:
			dead(Global.equipped_characters[1])
	elif Global.equipped_characters[2] == Global.current_character:
		if Global.hearts <= 0:
			dead(Global.equipped_characters[2])

func dead(character_id):
	is_dead = true
	get_parent().get_parent().is_invulnerable = true
	$InvulnerabilityTimer.start()
#	swap_to_nearby_alive_characters()
	if character_id == Global.equipped_characters[0]:
		Global.alive[0] = false
	elif character_id == Global.equipped_characters[1]:
		Global.alive[1] = false
	elif character_id == Global.equipped_characters[2]:
		Global.alive[2] = false
	
	$HurtAnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.4), "timeout")
	
	var alive_status : Array = [true, true, true]
	var counter : int = 0
	for c in Global.equipped_characters:
		if Global.character_list.find(Global.equipped_characters[counter]) != -1:
			if !Global.alive[counter]:
				alive_status[counter] = false
		else:
			alive_status[counter] = false
		counter += 1

	if !alive_status[0] and !alive_status[1] and !alive_status[2]:
		var counter_sec : int = 0
		for c in Global.equipped_characters:
			if Global.character_list.find(Global.equipped_characters[counter_sec]) != -1:
				get_parent().get_parent().heal(c, 999, true)
			counter_sec += 1
		get_parent().get_parent().get_parent().get_node("GameOverUI/GameOver").open_game_over_ui()


func add_hurt_particles(damage : float):
	var hurt_particle = get_parent().get_parent().HURT_PARTICLE.instance()
	hurt_particle.damage = damage * 2
	get_parent().get_parent().get_parent().add_child(hurt_particle)
	hurt_particle.position = global_position

func take_damage(damage : float):
	if Global.current_character == "Agnette":
		if current_form == forms.ARCHER:
			if Global.equipped_characters[0] == "Agnette":
				if get_parent().get_parent().shield_hp > 0:
					get_parent().get_parent().shield_hp = clamp(get_parent().get_parent().shield_hp - damage, 0, 999)
					get_parent().get_parent().get_node("Shield/ShieldHPBar").value = get_parent().get_parent().shield_hp
				else:
					Global.hearts -= damage
					add_hurt_particles(damage)
					emit_signal("life_changed", Global.hearts, "Agnette")
			elif Global.equipped_characters[1] == "Agnette":
				if get_parent().get_parent().shield_hp > 0:
					get_parent().get_parent().shield_hp = clamp(get_parent().get_parent().shield_hp - damage, 0, 999)
					get_parent().get_parent().get_node("Shield/ShieldHPBar").value = get_parent().get_parent().shield_hp
				else:
					Global.character2_hearts -= damage
					add_hurt_particles(damage )
					emit_signal("life_changed", Global.character2_hearts, "Agnette")
			elif Global.equipped_characters[2] == "Agnette":
				if get_parent().get_parent().shield_hp > 0:
					get_parent().get_parent().shield_hp = clamp(get_parent().get_parent().shield_hp - damage, 0, 999)
					get_parent().get_parent().get_node("Shield/ShieldHPBar").value = get_parent().get_parent().shield_hp
				else:
					Global.character3_hearts -= damage
					add_hurt_particles(damage)
					emit_signal("life_changed", Global.character3_hearts, "Agnette")
		elif current_form == forms.BEAR:
			
			$BearFormNodes/BearHealthBar.value -= damage * 2
			add_hurt_particles(damage)
			print("BEAR takes dmg")

func _on_ResetAttackStringTimer_timeout():
	attack_string_count = 4






func _on_EnemyEvasionArea_area_entered(area):
	pass # Replace with function body.


func _on_EnemyEvasionArea_area_exited(area):
	if Global.current_character == "Agnette":
		if get_parent().get_parent().is_dashing and area.is_in_group("Hostile"):
			get_parent().get_parent().is_invulnerable = true
			if !get_parent().get_parent().is_on_floor() and !get_parent().get_parent().get_node("HeightRaycast2D").is_colliding():
				get_parent().get_parent().airborne_mode = true
				get_parent().get_parent().get_node("AirborneTimer").start()
			Input.action_release("charge")
			emit_signal("perfect_dash")
			Engine.time_scale = 0.5
			yield(get_tree().create_timer(0.125), "timeout")
			Engine.time_scale = 1.0
			if $TempusTardusTriggerCD.is_stopped():
				var tempus_targus = TEMPUS_TARGUS.instance()
				get_parent().get_parent().get_parent().add_child(tempus_targus)
				tempus_targus.position = global_position
				$TempusTardusTriggerCD.start()
			get_parent().get_parent().is_invulnerable = false
		elif !get_parent().get_parent().is_dashing and area.is_in_group("Enemy"):
			get_parent().get_parent().perfect_dash = false


func _on_AirborneTimer_timeout():
	airborne_mode = false # Replace with function body.
	get_parent().get_parent().velocity.y = 0





func dash_effect():
	if get_parent().get_parent().is_dashing:
		yield(get_tree().create_timer(0.25), "timeout")



func _on_InvulnerabilityTimer_timeout():
	get_parent().get_parent().is_invulnerable = false



#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "SpecialAttack2_Right" or "SpecialAttack1_Right" or "SpecialAttack1_Left":
#		$SpecialAttackArea2D/CollisionShape2D.disabled = true


func _on_DashInputPressTimer_timeout():
	if Global.current_character == "Agnette" and !Input.is_action_pressed("ui_attack"):
		charged_dash()



func _on_ShootTimer_timeout():
	pass # Replace with function body.

func _on_InputPressTimer_timeout():
	if Input.is_action_pressed("ui_attack"):
		is_charging = true
		$ChargedAttackBarFillTimer.start()
		toggle_charged_attack_snare(true)
		$BowAnimationPlayer.play("BowAttackRightCharged")
		$MaxChargeHoldTimer.start()
func _on_ChargedAttackBarFillTimer_timeout():
	if is_charging:
		$ChargedAttackBar.value += 10
		$ChargedAttackBarFillTimer.start()
	else:
		$ChargedAttackBarFillTimer.stop()


func _on_MaxChargeHoldTimer_timeout():
	if is_charging:
		toggle_charged_attack_snare(false)
		is_charging = false
		if current_form == forms.ARCHER:
			charged_attack()
		$ChargedAttackBarFillTimer.stop()
		$ChargedAttackBar.value = $ChargedAttackBar.min_value


func _on_AttackCollision_area_entered(area):
	pass # Replace with function body.


func _on_AttackCollision_area_exited(area):
	pass # Replace with function body.


func _on_BearFormDurationTimer_timeout():
	if current_form == forms.BEAR:
		wild_shape(forms.ARCHER)
