class_name Glaciela extends Node2D

const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
signal skill_used(skill_name)
signal mana_changed(amount, character)
signal life_changed(amount, character)
signal attack_buff(amount, duration)
var target
# Attack buff for BASIC ATTACKS ONLY.
var atkbuffmulti = 0
var atkbuffdur = 0
# Attack buff for all abilities (Skills)
var atkbuffskill = 0
var buffed_from_attack_crystals = false
var prev_attack_power : Array
var number_of_atk_buffs : int = 0
var attack_string_count : int = 4
var restore_mana_for_all_parties : int = 2
var buffed_attack_power : float
var is_charging = false
onready var FULL_CHARGE_METER = preload("res://assets/UI/chargebar_full.png")
onready var CHARGING_CHARGE_METER = preload("res://assets/UI/chargebar_charging.png")

func _ready():
	connect("life_changed", get_parent().get_parent().get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	connect("mana_changed", get_parent().get_parent().get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
	connect("skill_used", get_parent().get_parent().get_parent().get_node("SkillsUI/Control"), "on_skill_used")
	connect("skill_used", get_parent().get_parent().get_node("SkillManager"), "on_skill_used")
	$AnimatedSprite.play("Default")
	$SpearSprite.visible = false
	$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack"] / 100)))
	

func _physics_process(delta):
	target = get_closest_enemy()
	
	if Global.current_character == "Glaciela":
		charge_meter()
		$AnimatedSprite.visible = true
		# Animation handling 
		if Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			Input.action_release("left")
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Walk")
			attack_string_count = 4
		if Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			Input.action_release("right")
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Walk")
			attack_string_count = 4
		if get_parent().get_parent().velocity.x == 0:
			$AnimatedSprite.play("Default")
		
		if get_parent().get_parent().can_dash:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right") and !Input.is_action_pressed("jump"):
				$AnimatedSprite.play("Walk")
				
			else:
				$AnimatedSprite.play("Default")
		if Input.is_action_just_pressed("ui_dash") and !get_parent().get_parent().can_dash and !get_parent().get_parent().get_node("DashUseTimer").is_stopped():
			$AnimatedSprite.play("Dash")
			attack_string_count = 4
			yield(get_tree().create_timer(0.25), "timeout")
			$AnimatedSprite.play("Default")
		
		if Input.is_action_just_pressed("jump"):
			attack_string_count = 4
			$AnimatedSprite.play("Default")
		if Input.is_action_just_pressed("ui_attack") and $MeleeTimer.is_stopped():
			if !$AnimatedSprite.flip_h:
				$SpearSprite.visible = true
				play_attack_animation("Right")
				$AttackCollision/CollisionShape2D.disabled = false
				get_parent().get_parent().attack_knock()
				$AttackCollision.set_scale(Vector2(1,1))
				$ChargedAttackCollision.set_scale(Vector2(1,1))
				$MeleeTimer.start()
			else:
				$SpearSprite.visible = true
				play_attack_animation("Left")
				$AttackCollision/CollisionShape2D.disabled = false
				get_parent().get_parent().attack_knock()
				$AttackCollision.set_scale(Vector2(-1,1))
				$ChargedAttackCollision.set_scale(Vector2(-1,1))
				$MeleeTimer.start()
		
		if $ChargeBar.value == $ChargeBar.max_value:
			if Input.is_action_pressed("ui_attack") and $ChargedAttackCooldown.is_stopped(): 
				if $TundraMeter.value >= 40:
					charged_attack(0.6)
					$TundraMeter.value -= 40
					
						
				else:
					Input.action_press("ui_attack")
			
		if Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill"):
			print("skill emitted")
			emit_signal("skill_used", "IceLance")

# Helper function, use this to change tundra stack value through a signal 
# from another node
func restore_tundra_stacks(amount : int):
	print("restored some")
	$TundraMeter.value += amount
func play_attack_animation(direction : String):
	if direction == "Right":
		match attack_string_count:
			4:
				$AnimationPlayer.play("SpearSwingRight1")
				attack_string_count -= 1
				$TundraMeter.value += 6
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack"] / 100) + buffed_attack_power))
						break
				
			3:
				$AnimationPlayer.play("SpearSwingRight2")
				attack_string_count -= 1
				$TundraMeter.value += 6
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack2"] / 100) + buffed_attack_power))
						break
			2:
				$AnimationPlayer.play("SpearSwingRight3")
				attack_string_count -= 1
				$TundraMeter.value += 6
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack3"] / 100) + buffed_attack_power))
						break
			1:
				$AnimationPlayer.play("SpearSwingRight4")
				attack_string_count -= 1
				$TundraMeter.value += 18
				attack_string_count = 4
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack4"] / 100) + buffed_attack_power))
						break

	elif direction == "Left":
		match attack_string_count:
			4:
				$AnimationPlayer.play("SpearSwingLeft1")
				attack_string_count -= 1
				$TundraMeter.value += 6
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack"] / 100) + buffed_attack_power))
						break
			3:
				$AnimationPlayer.play("SpearSwingLeft2")
				attack_string_count -= 1
				$TundraMeter.value += 6
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack2"] / 100) + buffed_attack_power))
						break
			2:
				$AnimationPlayer.play("SpearSwingLeft3")
				attack_string_count -= 1
				$TundraMeter.value += 6
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack3"] / 100) + buffed_attack_power))
						break
			1:
				$AnimationPlayer.play("SpearSwingLeft4")
				attack_string_count -= 1
				$TundraMeter.value += 18
				attack_string_count = 4
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(Global.glaciela_attack * (Global.glaciela_skill_multipliers["BasicAttack4"] / 100) + buffed_attack_power))
						break
	
func charge_meter():
	if Global.current_character == "Glaciela":
		$ChargingParticle.visible = true if is_charging else false
		if $ChargeBar.value == $ChargeBar.max_value:
			$ChargeBar.texture_progress = FULL_CHARGE_METER
		else:
			$ChargeBar.texture_progress = CHARGING_CHARGE_METER
		if get_parent().get_parent().is_on_floor():
			if Input.is_action_pressed("charge"):
				# Max value is 100
				$ChargeBar.visible = true
				$ChargeBar.value += 5
				is_charging = true
			if Input.is_action_just_released("charge") or Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("jump"):
				# Min value is 0 (Empty)
				$ChargeBar.visible = false
				$ChargeBar.value = $ChargeBar.min_value
				is_charging = false

func charged_attack(airborne_duration : float = 1):
		if target and target != null: 
			if target.get_node("Area2D").overlaps_area($ChargedAttackCollision) or target.get_node("Area2D").overlaps_area($ChargedAttackCollision2):
				var airborne_status : AirborneStatus = AIRBORNE_STATUS.instance()
				airborne_status.time = airborne_duration
				target.add_child(airborne_status)
				if !$AnimatedSprite.flip_h:
					$AnimationPlayer.play("ChargedAttackRight")
				else:
					$AnimationPlayer.play("ChargedAttackLeft")
				set_basic_attack_power(3, 0.1)
				$ChargedAttackCooldown.start()

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
	
func set_weapon_to_invisible():
	$SpearSprite.visible = false

# HOW ATTACK BUFFS WORK
# If active character gets into contact with an area with the group "Attackbuffmultiplier
# Do the thing where it iterates for a number which is the multiplier
# If active character gets into contact with an area with the group "Attackbufftimer"
# Do the thing where it iterates for a number which is the multiplier

func set_basic_attack_power(amount : float, duration : float, show_particles : bool = false):
	# DONT ASK THIS IS SO COMPLICATED ON GODDDD
		buffed_from_attack_crystals = true
		number_of_atk_buffs += 1
		var current_group = $AttackCollision.get_groups()
		
		
		var other_groups : Array
		for g in current_group:
			# Get other group tags
			if float(g) == 0 and !"_" in current_group and prev_attack_power.empty():
				other_groups.append(g)
				$AttackCollision.remove_from_group(g)
			# Get current attack value
			if !float(g) == 0:
				prev_attack_power.insert((number_of_atk_buffs - 1), float(g)) 
				$AttackCollision.remove_from_group(g)
		buffed_attack_power = prev_attack_power[number_of_atk_buffs - 1] + amount
		$AttackCollision.add_to_group(str(buffed_attack_power))
		print("Buffed: " + str(buffed_attack_power))
		for members in other_groups:
			$AttackCollision.add_to_group(members)
		yield(get_tree().create_timer(duration), "timeout")
		for g in $AttackCollision.get_groups():
			if int(g) != 0:
				$AttackCollision.remove_from_group(g)
		$AttackCollision.remove_from_group(str(buffed_attack_power))
		$AttackCollision.add_to_group(str(prev_attack_power[number_of_atk_buffs - 1]))
		print("DeBuffed: " + str(prev_attack_power[number_of_atk_buffs - 1]))
		buffed_attack_power = 0
		print($AttackCollision.get_groups())
		for members in other_groups:
			$AttackCollision.add_to_group(members)
		number_of_atk_buffs -= 1
		prev_attack_power.remove(number_of_atk_buffs)
		buffed_from_attack_crystals = false
		

func infuse_element(element : String, duration : float = 10):
	match element:
		"Ice":
			$AttackCollision.remove_from_group("Sword")
			$AttackCollision.add_to_group("Ice")
			yield(get_tree().create_timer(duration), "timeout")
			$AttackCollision.remove_from_group("Ice")
			$AttackCollision.add_to_group("Sword")

func _on_AttackCollision_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Enemy2"):
		var hitparticle = SWORD_HIT_PARTICLE.instance()
		var slashparticle = SWORD_SLASH_EFFECT.instance()
		hitparticle.emitting = true
		get_parent().get_parent().get_parent().add_child(hitparticle)
		get_parent().get_parent().get_parent().add_child(slashparticle)
		hitparticle.position = get_parent().get_parent().get_node("Position2D").global_position
		slashparticle.position = get_parent().get_parent().get_node("Position2D").global_position

			
			

func _on_MeleeTimer_timeout():
	$AttackCollision/CollisionShape2D.disabled = true


func _on_Area2D_area_entered(area):
	if Global.current_character == "Glaciela":
		if area.is_in_group("HealthPot"):
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		if area.is_in_group("LifeWine"):
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		if !Global.godmode:
			if get_parent().get_parent().inv_timer.is_stopped() and !get_parent().get_parent().is_invulnerable and !get_parent().get_parent().is_dashing:
				if area.is_in_group("Enemy") or area.is_in_group("DeflectedProjectile"):
					var groups = area.get_groups()
					groups.erase("Enemy")
					var damage = float(groups.max())
					take_damage(damage)
					get_parent().get_parent().add_hurt_particles(damage * 2)
					get_parent().get_parent().afterDamaged()
						
					get_parent().get_parent().is_gliding = false
					Input.action_release("charge")
					
					if !area.is_in_group("LightEnemy"):
						get_parent().get_parent().knockback()
					get_parent().get_parent().get_node("CampfireTimer").stop()
				if area.is_in_group("Enemy2"):
					Global.hearts -= 1
					get_parent().get_parent().add_hurt_particles(1)
					get_parent().get_parent().is_gliding = false
					Input.action_release("charge")
					get_parent().get_parent().afterDamaged()
					get_parent().get_parent().knockback()
					get_parent().get_parent().get_node("CampfireTimer").stop()
			if area.is_in_group("Spike"):
				Global.hearts -= 0.5
				Input.action_release("charge")
				get_parent().get_parent().afterDamaged()
				get_parent().get_parent().get_node("CampfireTimer").stop()
		if area.is_in_group("SlowingPoison"):
			get_parent().get_parent().slow_player(2.0)
		if area.is_in_group("Transporter"):
			get_parent().get_parent().emit_signal("level_changed")
		if area.is_in_group("AttackBuff"):
			atkbuffmulti = area.amount
			atkbuffdur = area.duration
			set_basic_attack_power(float(atkbuffmulti), float(atkbuffdur))
			print("STRONK")
#	if area.is_in_group("Enemy") and !get_parent().get_parent().is_invulnerable:
#		$AnimationPlayer.play("Hurt")

func take_damage(damage : float):
	if Global.current_character == "Glaciela":
		if Global.equipped_characters[0] == "Glaciela":
			Global.hearts -= damage
			emit_signal("life_changed", Global.hearts, "Glaciela")
		elif Global.equipped_characters[1] == "Glaciela":
			Global.character2_hearts -= damage
			emit_signal("life_changed", Global.character2_hearts, "Glaciela")
		elif Global.equipped_characters[2] == "Glaciela":
			Global.character3_hearts -= damage
			emit_signal("life_changed", Global.character3_hearts, "Glaciela")





func _on_ResetAttackStringTimer_timeout():
	pass # Replace with function body.


