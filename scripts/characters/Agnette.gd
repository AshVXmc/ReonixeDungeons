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


func _ready():
	print("agnette:" + str(Global.character3_hearts))
	
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
	connect("skill_used", get_parent().get_parent().get_parent().get_node("SkillsUI/Control"), "on_skill_used")
	connect("skill_used", get_parent().get_parent().get_node("SkillManager"), "on_skill_used")
	$StrongJumpParticle.visible = false
	$AnimatedSprite.play("Default")


	$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack1_1"] / 100)))


func _physics_process(delta):
	target = get_closest_enemy()
	if !$AnimatedSprite.flip_h:
		$EnemyEvasionArea.set_scale(Vector2(1,1))
	else:
		$EnemyEvasionArea.set_scale(Vector2(-1,1))
		
		
	if Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
		Input.action_release("left")
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
		
#		attack_string_count = 4
	elif Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
		Input.action_release("right")
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
#		attack_string_count = 4
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") and attack_string_count != 3:
		attack_string_count = 4
	if Global.current_character == "Agnette":
#		charge_meter()
		$AnimatedSprite.visible = true
		
		if !$AnimatedSprite.flip_h:
			$BowSprite.flip_h = true
			$BowSprite.position.x = 40
		else:
			$BowSprite.flip_h = false
			$BowSprite.position.x = -40
			
		if get_parent().get_parent().velocity.x == 0:
			$AnimatedSprite.play("Default")
		
		if get_parent().get_parent().can_dash:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right") and !Input.is_action_pressed("jump"):
				$AnimatedSprite.play("Walk")
			else:
				$AnimatedSprite.play("Default")
		if Input.is_action_just_pressed("ui_dash") and !get_parent().get_parent().can_dash and !get_parent().get_parent().get_node("DashUseTimer").is_stopped():
			$AnimatedSprite.play("Dash")
			print("text")
#			attack_string_count = 4
			yield(get_tree().create_timer(0.25), "timeout")
			$AnimatedSprite.play("Default")
		
		if Input.is_action_just_pressed("jump"):
#			attack_string_count = 4
			$AnimatedSprite.play("Default")
		


			
		if Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill"):
			print("skill emitted")
			emit_signal("skill_used", "IceLance")

func _input(event):
	if Global.current_character == "Agnette":
		if event.is_action_pressed("ui_attack"):
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
			is_charging = false
			charged_attack()
			$ChargedAttackBarFillTimer.stop()
			$ChargedAttackBar.value = $ChargedAttackBar.min_value

func charged_attack():
	# the arrow deals earth damage and builds earth trauma
	if $ShootTimer.is_stopped():
		spawn_arrow($ChargedAttackBar.value)
	
	
func charged_dash():
	$DashInputPressTimer.stop()
func attack():
	if Global.current_character == "Agnette" and $ShootTimer.is_stopped():
#		if get_parent().get_parent().is_on_floor():
		airborne_mode = true
		$AirborneTimer.start()
		spawn_arrow()
		$ShootTimer.start()

func spawn_arrow(charge_value : int = 0):
	var charged_bonus : float = 1 + (3 * charge_value / 100)
	var arrow = ARROW.instance()
	get_parent().get_parent().get_parent().add_child(arrow)
	arrow.get_node("Area2D").add_to_group(str(charged_bonus * Global.agnette_attack * (Global.agnette_skill_multipliers["Arrow1"] / 100)))
	
	if !$AnimatedSprite.flip_h:
		arrow.position.x = global_position.x + 40
		arrow.position.y = global_position.y
	else:
		arrow.position.x = global_position.x - 40
		arrow.position.y = global_position.y
		arrow.x_direction = -1

func play_attack_animation():
	pass

func is_a_critical_hit() -> bool:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var num = rng.randi_range(0 ,100)
	if num <= Global.glaciela_skill_multipliers["CritRate"]:
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
					print("GLACIELA HURT")
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
		if Global.equipped_characters[0] == "Agnette":
			Global.hearts -= damage
			add_hurt_particles(damage)
			emit_signal("life_changed", Global.hearts, "Agnette")
		elif Global.equipped_characters[1] == "Agnette":
			Global.character2_hearts -= damage
			add_hurt_particles(damage )
			emit_signal("life_changed", Global.character2_hearts, "Agnette")
		elif Global.equipped_characters[2] == "Agnette":
			Global.character3_hearts -= damage
			add_hurt_particles(damage)
			emit_signal("life_changed", Global.character3_hearts, "Agnette")

	

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
	$ChargedAttackBar.visible = true
	if Input.is_action_pressed("ui_attack"):
		is_charging = true
		$ChargedAttackBarFillTimer.start()
#	else:
#		is_charging = false
#		$ChargedAttackBarFillTimer.stop()
#		$ChargedAttackBar.value = $ChargedAttackBar.min_value

func _on_ChargedAttackBarFillTimer_timeout():
	if is_charging:
		$ChargedAttackBar.value += 10
		$ChargedAttackBarFillTimer.start()
	else:
		$ChargedAttackBarFillTimer.stop()
