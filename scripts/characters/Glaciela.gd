class_name Glaciela extends Node2D

const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
const TEMPUS_TARGUS : PackedScene = preload("res://scenes/misc/TempusTardus.tscn")
const HEAL_PARTICLE : PackedScene = preload("res://scenes/particles/HealIndicatorParticle.tscn")
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
var tundra_stars : int = 0
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
var ice_dmg_bonus_from_tundra_sigil : float

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
onready var FULL_CHARGE_METER = preload("res://assets/UI/chargebar_full.png")
onready var CHARGING_CHARGE_METER = preload("res://assets/UI/chargebar_charging.png")

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

onready var sskill_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("SkillsUI/Control/SecondarySkill/Glaciela/IceLance/TextureProgress")



func _ready():
#	print(get_path())
	if Global.equipped_characters.has("Player"):
		connect("trigger_quickswap", get_parent().get_parent(), "quickswap_event")
	tundra_stars = 0
	update_tundra_sigil_ui()
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
	$SpearSprite.visible = false
	$AttackCollision.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["BasicAttack"] / 100)))
	$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack1_1"] / 100)))

func update_tundra_sigil_ui():
	$TundraStarsUI/TundraStars3.visible = true if tundra_stars >= 3 else false
	$TundraStarsUI/TundraStars2.visible = true if tundra_stars >= 2 else false
	$TundraStarsUI/TundraStars1.visible = true if tundra_stars >= 1 else false
	ice_dmg_bonus_from_tundra_sigil = Global.glaciela_skill_multipliers["TundraStarsIceDamageBonus"] * tundra_stars * 0.01
	print(ice_dmg_bonus_from_tundra_sigil)
	print("stack gaine")
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
	if Global.current_character == "Glaciela":
		charge_meter()
		$AnimatedSprite.visible = true
		if $AnimatedSprite.flip_h:
			$ChargedAttackCollision.set_scale(Vector2(-1,1))
		else:
			$ChargedAttackCollision.set_scale(Vector2(1,1))
		# Animation handling 

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
		
		if $ChargedAttackCooldown.is_stopped():
			charged_attack(7.5)
		use_skill()

			
#		if Input.is_action_just_pressed("secondary_skill") and !Input.is_action_just_pressed("primary_skill"):
#			print("biatch")
#			emit_signal("skill_used", "IceLance")
		
func _input(event):
	if Global.current_character == "Glaciela":
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

func use_skill():
	if Global.current_character == "Glaciela":
		if sskill_ui.value >= sskill_ui.max_value and Input.is_action_just_pressed("secondary_skill") and !Input.is_action_just_pressed("primary_skill") and !get_parent().get_parent().is_frozen and !get_parent().get_parent().is_using_secondary_skill:
			use_secondary_skill()

func use_secondary_skill():
	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
		emit_signal("skill_used", "IceLance", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "IceLance")
		emit_signal("mana_changed", Global.mana, "Glaciela")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
		emit_signal("skill_used", "IceLance", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "IceLance")
		emit_signal("mana_changed", Global.character2_mana, "Glaciela")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
		emit_signal("skill_used", "IceLance", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "IceLance")
		emit_signal("mana_changed", Global.character3_mana, "Glaciela")


func charged_dash():
	$DashInputPressTimer.stop()
func attack():
	if Global.current_character == "Glaciela" and $MeleeTimer.is_stopped():
		if get_parent().get_parent().is_on_floor():
			airborne_mode = true
			$AirborneTimer.start()
		
		if !$AnimatedSprite.flip_h:
			$SpearSprite.visible = true
			
			$AttackCollision/CollisionShape2D.disabled = false
			play_attack_animation("Right")
			$AttackCollision.set_scale(Vector2(1,1))
			$ChargedAttackCollision.set_scale(Vector2(1,1))
			$MeleeTimer.start()
		else:
			$SpearSprite.visible = true
			
			$AttackCollision/CollisionShape2D.disabled = false
			play_attack_animation("Left")
			$AttackCollision.set_scale(Vector2(-1,1))
			$ChargedAttackCollision.set_scale(Vector2(-1,1))
			$MeleeTimer.start()
		$AttackTimer.start()
# Helper function, use this to change tundra stack value through a signal 
# from another node
func is_a_critical_hit() -> bool:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var num = rng.randi_range(0 ,100)
	if num <= Global.glaciela_skill_multipliers["CritRate"]:
		return true
	else:
		return false
		
func play_attack_animation(direction : String):
	
	if direction == "Right":
		match attack_string_count:
			4:
				$ResetAttackStringTimer.stop()
				$AnimationPlayer.play("SpearSwingRight1")
				var crit_dmg : float = 1.0
				attack_string_count -= 1
				if is_a_critical_hit():
					crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
					$AttackCollision.add_to_group("IsCritHit")
				else:
					$AttackCollision.remove_from_group("IsCritHit")
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str((ATTACK * (Global.glaciela_skill_multipliers["BasicAttack"] / 100) + basic_attack_buff) * crit_dmg))
						$AttackCollision.add_to_group("GlacielaBasicAttackOne")
						break
				
				$ResetAttackStringTimer.start()
			3:
				$ResetAttackStringTimer.stop()
				$AnimationPlayer.play("SpearSwingRight2")
				var crit_dmg : float = 1.0
				attack_string_count -= 1
				if is_a_critical_hit():
					crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
					$AttackCollision.add_to_group("IsCritHit")
				else:
					$AttackCollision.remove_from_group("IsCritHit")
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str((ATTACK * (Global.glaciela_skill_multipliers["BasicAttack2"] / 100) + basic_attack_buff) * crit_dmg))
						$AttackCollision.add_to_group("GlacielaBasicAttackTwo")
						break
				$SpecialAttackTimer.start()
				$ResetAttackStringTimer.start()
			2:
				$SpecialAttackTimer.stop()
				if $SpecialSequenceWindow.is_stopped():
					$AttackCollision/CollisionShape2D.disabled = true
					$SpecialAttackArea2D.set_scale(Vector2(1,1))
					$AnimationPlayer.play("SpecialAttack2_Right")
					attack_string_count = 4
				else:
					
					$AnimationPlayer.play("SpearSwingRight3")
					attack_string_count -= 1
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$AttackCollision.add_to_group("IsCritHit")
					else:
						$AttackCollision.remove_from_group("IsCritHit")
					for groups in $AttackCollision.get_groups():
						if float(groups) != 0:
							$AttackCollision.remove_from_group(groups)
							$AttackCollision.add_to_group(str((ATTACK * (Global.glaciela_skill_multipliers["BasicAttack3"] / 100) + basic_attack_buff) * crit_dmg))
							$AttackCollision.add_to_group("GlacielaBasicAttackThree")
							break
					$ResetAttackStringTimer.start()
					$SpecialAttackTimer.start()
				
			1:
				
				$SpecialAttackTimer.stop()
				if $SpecialSequenceWindow.is_stopped():
					$AttackCollision/CollisionShape2D.disabled = true
					$SpecialAttackArea2D.set_scale(Vector2(1,1))
					$AnimationPlayer.play("SpecialAttack1_Right")
					attack_string_count = 4
#					yield(get_tree().create_timer($MeleeTimer.wait_time * 1.5), "timeout")
#					attack_string_count = 4
#					emit_signal("trigger_quickswap", "Glaciela")
				else:
					
					$AnimationPlayer.play("SpearSwingRight4")
#					attack_string_count -= 1
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$AttackCollision.add_to_group("IsCritHit")
					else:
						$AttackCollision.remove_from_group("IsCritHit")
					for groups in $AttackCollision.get_groups():
						if float(groups) != 0:
							$AttackCollision.remove_from_group(groups)
							$AttackCollision.add_to_group(str((ATTACK * (Global.glaciela_skill_multipliers["BasicAttack4"] / 100) + basic_attack_buff) * crit_dmg))
							$AttackCollision.add_to_group("GlacielaBasicAttackFour")
							break
#					if tundra_stars < Global.glaciela_skill_multipliers["MaxTundraStars"]:
#						tundra_stars += 1
#						update_tundra_sigil_ui()
#					yield(get_tree().create_timer($MeleeTimer.wait_time * 1.5), "timeout")
					attack_string_count = 4
#					emit_signal("trigger_quickswap", "Glaciela")
				
	elif direction == "Left":
		match attack_string_count:
			4:
				$ResetAttackStringTimer.stop()
				$AnimationPlayer.play("SpearSwingLeft1")
				attack_string_count -= 1
				print("ACTIVATUS TOTALUS")
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["BasicAttack"] / 100) + basic_attack_buff))
						$AttackCollision.add_to_group("GlacielaBasicAttackOne")
						break
				$ResetAttackStringTimer.start()
				print("GOING ONCE")
			3:
				$ResetAttackStringTimer.stop()
				$AnimationPlayer.play("SpearSwingLeft2")
				attack_string_count -= 1
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["BasicAttack2"] / 100) + basic_attack_buff))
						$AttackCollision.add_to_group("GlacielaBasicAttackTwo")
						break
				$ResetAttackStringTimer.start()
			2:
				$ResetAttackStringTimer.stop()
				$AnimationPlayer.play("SpearSwingLeft3")
				attack_string_count -= 1
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["BasicAttack3"] / 100) + basic_attack_buff))
						$AttackCollision.add_to_group("GlacielaBasicAttackThree")
						break
				$SpecialAttackTimer.start()
				$ResetAttackStringTimer.start()
			1:
				
				$SpecialAttackTimer.stop()
				if $SpecialSequenceWindow.is_stopped():
					$AttackCollision/CollisionShape2D.disabled = true
					$SpecialAttackArea2D.set_scale(Vector2(-1,1))
					$AnimationPlayer.play("SpecialAttack1_Left")
					attack_string_count = 4
#					yield(get_tree().create_timer($MeleeTimer.wait_time * 1.5), "timeout")
#					attack_string_count = 4
#					emit_signal("trigger_quickswap", "Glaciela")
					
				else:
					
					$AnimationPlayer.play("SpearSwingLeft4")
#					attack_string_count -= 1
					for groups in $AttackCollision.get_groups():
						if float(groups) != 0:
							$AttackCollision.remove_from_group(groups)
							$AttackCollision.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["BasicAttack4"] / 100) + basic_attack_buff))
							$AttackCollision.add_to_group("GlacielaBasicAttackFour")
							break
#					if tundra_stars < Global.glaciela_skill_multipliers["MaxTundraStars"]:
#						tundra_stars += 1
#						update_tundra_sigil_ui()
#					yield(get_tree().create_timer($MeleeTimer.wait_time * 1.5), "timeout")
					attack_string_count = 4
#					emit_signal("trigger_quickswap", "Glaciela")
#				$ResetAttackStringTimer.start()
func change_mana_value(amount : float):
	if Global.current_character == Global.equipped_characters[0] and Global.mana < Global.max_mana:
		Global.mana += amount
		emit_signal("mana_changed", Global.mana, "Glaciela")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana < Global.character2_max_mana:
		Global.character2_mana += amount
		emit_signal("mana_changed", Global.character2_mana, "Glaciela")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana < Global.character3_max_mana:
		Global.character3_mana += amount
		emit_signal("mana_changed", Global.character3_mana, "Glaciela")
func add_heal_particles(heal_amount : float):
	var heal_particle = HEAL_PARTICLE.instance()
	heal_particle.heal_amount = heal_amount * 2
	get_parent().get_parent().get_parent().add_child(heal_particle)
	heal_particle.position = global_position
func heal(heal_amount : float, heal_to_max : bool = false, consumes_potion : bool = true):
	# heal amount in percentage based on max HP
	if Global.equipped_characters[0] == "Glaciela":
		add_heal_particles(clamp(heal_amount, 0, Global.max_hearts - Global.hearts))
		Global.hearts += clamp(heal_amount, 0, Global.max_hearts - Global.hearts)
		emit_signal("life_changed", Global.hearts, "Glaciela")
	elif Global.equipped_characters[1] == "Glaciela":
		add_heal_particles(clamp(heal_amount, 0, Global.character_2_max_hearts - Global.character2_hearts))
		Global.character2_hearts += clamp(heal_amount, 0, Global.character_2_max_hearts - Global.character2_hearts)
		emit_signal("life_changed", Global.character2_hearts, "Glaciela")
		print("healed")
	elif Global.equipped_characters[2] == "Glaciela":
		add_heal_particles(clamp(heal_amount, 0, Global.character_3_max_hearts - Global.character3_hearts))
		Global.character3_hearts += clamp(heal_amount, 0, Global.character_3_max_hearts - Global.character3_hearts)
		emit_signal("life_changed", Global.character3_hearts, "Glaciela")
	if consumes_potion:
		Global.healthpot_amount -= 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)
	

func _on_SpecialAttackTimer_timeout():
	$SpecialSequenceWindow.start()
	
func charge_meter():
	if Global.current_character == "Glaciela":
		$ChargingParticle.visible = true if is_charging else false

				

#func downwards_charged_attack():
#	if airborne_mode and Input.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped() and !is_performing_charged_attack:
#		if target and target != null and weakref(target).get_ref() != null: 
#			if !target.is_in_group("Armored") and target.get_node("Area2D").overlaps_area($ChargedAttackCollision):
#				pass
#
#
		
func charged_attack(airborne_duration : float = 1, type : int = 1):
	if $KnockAirborneICD.is_stopped() and get_parent().get_parent().is_on_floor() and Input.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped() and !is_performing_charged_attack:
		attack_string_count = 4
#		airborne_mode = false
		is_performing_charged_attack = true
		if !$AnimatedSprite.flip_h:
			print("Played anim")
			$AnimationPlayer.play("ChargedAttackRight")
		else:
			$AnimationPlayer.play("ChargedAttackLeft")

		if target and target != null and weakref(target).get_ref() != null: 
			if !target.is_in_group("Armored") and target.get_node("Area2D").overlaps_area($ChargedAttackCollision): 
				if !target.get_node("Area2D").is_in_group("IsAirborne") and !get_parent().get_parent().airborne_mode:
					for groups in $ChargedAttackCollision.get_groups():
						if float(groups) != 0:
							$ChargedAttackCollision.remove_from_group(groups)
							if !airborne_mode:
								$ChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["BasicAttack"] / 100) + basic_attack_buff))
								print("a")
							else:
								$ChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["AirborneBasicAttack"] / 100) + basic_attack_buff))
								print("b")
							break
					$KnockAirborneICD.start()
					if $TundraSigilChargedAttackGainDelayTimer.is_stopped():
						tundra_stars += 1
						$TundraSigilChargedAttackGainDelayTimer.start()
					update_tundra_sigil_ui()
					is_charging = false
					is_performing_charged_attack = true
	#				get_parent().get_parent().airborne_mode = false
					var airborne_status : AirborneStatus = AIRBORNE_STATUS.instance()
	#				airborne_status.time = airborne_duration
					target.add_child(airborne_status)
					var hitparticle = SWORD_HIT_PARTICLE.instance()
					hitparticle.emitting = true
					get_parent().get_parent().get_parent().add_child(hitparticle)
					hitparticle.position = target.global_position

					set_basic_attack_power(3, 0.1)
					$ChargedAttackCooldown.start()
					get_parent().get_parent().velocity.y = 0
					get_parent().get_parent().velocity.y = -1050

					yield(get_tree().create_timer(0.25), "timeout")
					airborne_mode = true
	#				Input.action_release("jump")
					is_performing_charged_attack = false
					
				elif target.get_node("Area2D").is_in_group("IsAirborne") and get_parent().get_parent().airborne_mode:
					# Aerial charged attack
					for groups in $ChargedAttackCollision.get_groups():
						if float(groups) != 0:
							$ChargedAttackCollision.remove_from_group(groups)
							if !airborne_mode:
								$ChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["BasicAttack"] / 100) + basic_attack_buff))
								print("a")
							else:
								$ChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["AirborneBasicAttack"] / 100) + basic_attack_buff))
								print("b")
							break
			Input.action_release("ui_attack")
			is_performing_charged_attack = false

func special_attack_1_damage_calc(sequence : int = 1):
	for groups in $SpecialAttackArea2D.get_groups():
		if float(groups) != 0:
			$SpecialAttackArea2D.remove_from_group(groups)
			match sequence:
				1:
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$SpecialAttackArea2D.add_to_group("IsCritHit")
					else:
						$SpecialAttackArea2D.remove_from_group("IsCritHit")
					$SpecialAttackArea2D.add_to_group("HeavyPoiseDamage")
					$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack1_1"] / 100) * (1 + ice_dmg_bonus + ice_dmg_bonus_from_tundra_sigil) * crit_dmg))
					
				2:
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$SpecialAttackArea2D.add_to_group("IsCritHit")
					else:
						$SpecialAttackArea2D.remove_from_group("IsCritHit")
					$SpecialAttackArea2D.add_to_group("HeavyPoiseDamage")
					$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack1_2"] / 100) * (1 + ice_dmg_bonus + ice_dmg_bonus_from_tundra_sigil) * crit_dmg))
					

func special_attack_2_damage_Calc(sequence : int = 1):
	for groups in $SpecialAttackArea2D.get_groups():
		if float(groups) != 0:
			$SpecialAttackArea2D.remove_from_group(groups)
			match sequence:
				1:
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$SpecialAttackArea2D.add_to_group("IsCritHit")
					else:
						$SpecialAttackArea2D.remove_from_group("IsCritHit")
					$SpecialAttackArea2D.add_to_group("LightPoiseDamage")
					$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack2_1"] / 100) * (1 + ice_dmg_bonus + ice_dmg_bonus_from_tundra_sigil) * crit_dmg))
				2:
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$SpecialAttackArea2D.add_to_group("IsCritHit")
					else:
						$SpecialAttackArea2D.remove_from_group("IsCritHit")
					$SpecialAttackArea2D.add_to_group("LightPoiseDamage")
					$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack2_2"] / 100) * (1 + ice_dmg_bonus + ice_dmg_bonus_from_tundra_sigil) * crit_dmg))
				3:
					var crit_dmg : float = 1.0
					if is_a_critical_hit():
						crit_dmg = (Global.glaciela_skill_multipliers["CritDamage"] / 100 + 1)
						$SpecialAttackArea2D.add_to_group("IsCritHit")
					else:
						$SpecialAttackArea2D.remove_from_group("IsCritHit")
					$SpecialAttackArea2D.add_to_group("MediumPoiseDamage")
					$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack2_3"] / 100) * (1 + ice_dmg_bonus + ice_dmg_bonus_from_tundra_sigil) * crit_dmg))
					
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
	

func infuse_element(element : String, duration : float = 10):
	match element:
		"Ice":
			$AttackCollision.remove_from_group("Sword")
			$AttackCollision.add_to_group("Ice")
			yield(get_tree().create_timer(duration), "timeout")
			$AttackCollision.remove_from_group("Ice")
			$AttackCollision.add_to_group("Sword")

func _on_AttackCollision_area_entered(area):
	if weakref(area).get_ref() != null:
		if area.is_in_group("Enemy") or area.is_in_group("Enemy2"):
			if !get_parent().get_parent().is_on_floor() and !get_parent().get_parent().get_node("HeightRaycast2D").is_colliding():
				get_parent().get_parent().airborne_mode = true
				get_parent().get_parent().get_node("AirborneTimer").stop()
				get_parent().get_parent().get_node("AirborneTimer").start()
			if $TundraStackRegen.is_stopped() and !is_performing_charged_attack and tundra_stars < Global.glaciela_skill_multipliers["MaxTundraStars"]:
				if attack_string_count == 4:
					tundra_stars += 1
					update_tundra_sigil_ui()
					$TundraStackRegen.start()
				
			emit_signal("change_elegance", "BasicAttack")
			change_mana_value(0.25)
			var hitparticle = SWORD_HIT_PARTICLE.instance()
			var slashparticle = SWORD_SLASH_EFFECT.instance()
			hitparticle.emitting = true
			get_parent().get_parent().get_parent().add_child(hitparticle)
			get_parent().get_parent().get_parent().add_child(slashparticle)
			hitparticle.position = get_parent().get_parent().get_node("Position2D").global_position
			slashparticle.position = get_parent().get_parent().get_node("Position2D").global_position
			slashparticle.regular_slash_animation()
			yield(get_tree().create_timer(0.1),"timeout")
		
	if weakref(area).get_ref() != null:
		if area.is_in_group("Airborne") and !is_performing_charged_attack:
			get_parent().get_parent().get_node("AirborneTimer").start()
			get_parent().get_parent().airborne_mode = true
			airborne_mode = true

#func _on_MeleeTimer_timeout():
#	$AttackCollision/CollisionShape2D.disabled = true


func _on_Area2D_area_entered(area):
	if Global.current_character == "Glaciela":
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

func dead(character):
	pass


func add_hurt_particles(damage : float):
	var hurt_particle = get_parent().get_parent().HURT_PARTICLE.instance()
	hurt_particle.damage = damage * 2
	get_parent().get_parent().get_parent().add_child(hurt_particle)
	hurt_particle.position = global_position

func take_damage(damage : float):
	if Global.current_character == "Glaciela":
		if Global.equipped_characters[0] == "Glaciela":
			Global.hearts -= damage
			add_hurt_particles(damage)
			emit_signal("life_changed", Global.hearts, "Glaciela")
		elif Global.equipped_characters[1] == "Glaciela":
			Global.character2_hearts -= damage
			add_hurt_particles(damage )
			emit_signal("life_changed", Global.character2_hearts, "Glaciela")
		elif Global.equipped_characters[2] == "Glaciela":
			Global.character3_hearts -= damage
			add_hurt_particles(damage)
			emit_signal("life_changed", Global.character3_hearts, "Glaciela")

	

func _on_ResetAttackStringTimer_timeout():
	attack_string_count = 4





#func _on_TundraStackRegen_timeout():
#	if tundra_stars < Global.glaciela_skill_multipliers["MaxTundraSigils"]:
#		tundra_stars += 1



func _on_EnemyEvasionArea_area_entered(area):
	pass # Replace with function body.


func _on_EnemyEvasionArea_area_exited(area):
	if Global.current_character == "Glaciela":
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


func _on_AttackCollision_area_exited(area):
	if area.is_in_group("Enemy"):
		pass


func _on_TundraStackRegen_timeout():
	pass # Replace with function body.



func dash_effect():
	if get_parent().get_parent().is_dashing:
		yield(get_tree().create_timer(0.25), "timeout")

func _on_Special4thSequenceWindow_timeout():
#	attack_string_count = 4
	pass


func _on_InvulnerabilityTimer_timeout():
	get_parent().get_parent().is_invulnerable = false


func _on_AttackTimer_timeout():
	$AttackCollision/CollisionShape2D.disabled = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SpecialAttack2_Right" or "SpecialAttack1_Right" or "SpecialAttack1_Left":
		$SpecialAttackArea2D/CollisionShape2D.disabled = true


func _on_DashInputPressTimer_timeout():
	if Global.current_character == "Glaciela" and !Input.is_action_pressed("ui_attack"):
		charged_dash()

