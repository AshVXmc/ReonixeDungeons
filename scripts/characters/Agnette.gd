class_name Agnette extends Node2D

const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const RAIN_OF_ARROWS : PackedScene = preload("res://scenes/skills/RainOfArrows.tscn")
const TEMPUS_TARGUS : PackedScene = preload("res://scenes/misc/TempusTardus.tscn")
const HEAL_PARTICLE : PackedScene = preload("res://scenes/particles/HealIndicatorParticle.tscn")
const ARROW = preload("res://scenes/skills/AgnetteArrow.tscn")
const SEEKING_ARROW = preload("res://scenes/skills/SeekingArrow.tscn")
const RAVEN_PROJECTILE = preload("res://scenes/skills/RavenProjectile.tscn")
const RAVEN_TEMPEST = preload("res://scenes/skills/RavenTempest.tscn")
const VERTICAL_FLYING_SPEED : int = 300
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
signal update_spikegrowth_charges_ui(charges)
var target
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
var ATTACK = Global.agnette_attack
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
onready var sskill_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("SkillsUI/Control/SecondarySkill/Agnette/RavenForm/TextureProgress")
onready var tskill_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("SkillsUI/Control/TertiarySkill/Agnette/SpikeGrowth/TextureProgress")
onready var stamina_bar_ui : TextureProgress = get_parent().get_parent().get_parent().get_node("StaminaBarUI/StaminaBarUI/TextureProgress")
var bear_is_attacking : bool = false
var raven_is_attacking : bool = false
var facing
enum {
	left, right
}
var current_form = forms.ARCHER
enum forms  {
	ARCHER, BEAR, RAVEN
}
var is_wild_shaping : bool = false
func set_attack_buff_value(new_value):
	attack_buff = new_value
	ATTACK = Global.attack_power + attack_buff
func _ready():
	print(get_path())
	
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
	connect("update_spikegrowth_charges_ui", get_parent().get_parent().get_parent().get_node("SkillsUI/Control"), "update_spikegrowth_skill_ui")
	connect("skill_used", get_parent().get_parent().get_node("SkillManager"), "on_skill_used")
	$StrongJumpParticle.visible = false
	play_animated_sprite("Default")
	$BearFormDurationTimer.wait_time = Global.agnette_skill_multipliers["BearFormDuration"]
	$BearFormNodes/AttackCollision.add_to_group(str(ATTACK * (Global.agnette_skill_multipliers["BearFormAttack1"] / 100)))
	$RavenFormNodes/AttackCollision.add_to_group(str(ATTACK * (Global.agnette_skill_multipliers["RavenFormPeckAttack"] / 100)))
	$RavenFormDurationTimer.wait_time = Global.agnette_skill_multipliers["RavenFormDuration"]
#	$SpecialAttackArea2D.add_to_group(str(ATTACK * (Global.glaciela_skill_multipliers["SpecialAttack1_1"] / 100)))
	if Global.agnette_talents["VolleyShot"]["unlocked"] and Global.agnette_talents["VolleyShot"]["enabled"]:
		$TalentsNode2D/VolleyShootCooldownTimer.wait_time = Global.agnette_talents["VolleyShot"]["cooldown"]
	if Global.agnette_talents["StormyTempest"]["unlocked"] and Global.agnette_talents["StormyTempest"]["enabled"]:
		$TalentsNode2D/StormyTempestCDTimer.wait_time = Global.agnette_talents["StormyTempest"]["cooldown"]

func _physics_process(delta):
	target = get_closest_enemy()
	if !$AnimatedSprite.flip_h:
		$EnemyEvasionArea.set_scale(Vector2(1,1))
	else:
		$EnemyEvasionArea.set_scale(Vector2(-1,1))
	
	if $ChargedAttackBar.value > $ChargedAttackBar.min_value and Global.current_character != "Agnette":
		is_charging = false
		toggle_charged_attack_snare(false)
		$ChargedAttackBarFillTimer.stop()
		$ChargedAttackBar.value = $ChargedAttackBar.min_value
	
	if !bear_is_attacking:
		pass
#		attack_string_count = 4
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") and attack_string_count != 3:
		attack_string_count = 4
	if Global.current_character == "Agnette":
		if Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			facing = left
		elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_knocked_back and !get_parent().get_parent().is_dashing:
			facing = right
		else:
			facing = null
		if facing == left:
			Input.action_release("right")
			$AnimatedSprite.flip_h = true
		elif facing == right:
			Input.action_release("left")
			$AnimatedSprite.flip_h = false
		if !bear_is_attacking:
			if get_parent().get_parent().velocity.x <= 5 and get_parent().get_parent().velocity.x >= -5:
				play_animated_sprite("Default")
			else:
				play_animated_sprite("Walk")
				

		if current_form == forms.ARCHER:
			if Input.is_action_just_pressed("ui_dash") and !get_parent().get_parent().can_dash and !get_parent().get_parent().get_node("DashUseTimer").is_stopped():
				$AnimatedSprite.play("Dash")
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
				$BearFormNodes/AttackCollision.position.x = 140
			else:
				$BearFormNodes/AttackCollision.position.x = -140
			
			if !Input.is_action_pressed("ui_attack") and !$BearFormNodes/BearInputPressTimer.is_stopped():
				$BearFormNodes/BearInputPressTimer.stop()
		if current_form == forms.RAVEN:
			if !$AnimatedSprite.flip_h:
				$RavenFormNodes/AttackCollision.position.x = 95
			else:
				$RavenFormNodes/AttackCollision.position.x = -95
			
			if !Input.is_action_pressed("ui_attack") and !$RavenFormNodes/RavenInputPressTimer.is_stopped():
				$RavenFormNodes/RavenInputPressTimer.stop()
				
		$WeakenParticles.visible = true if !$WeakenedTimer.is_stopped() else false
		use_skill()
#		print(is_charging)
	if current_form == forms.RAVEN and get_parent().get_parent().can_fly:
		if get_parent().get_parent().stamina_bar_ui.value > Global.agnette_skill_multipliers["RavenFormFlightStaminaCost"] * 3 and Input.is_action_pressed("ui_up") or Input.is_action_pressed("jump"):
			get_parent().get_parent().velocity.y = -VERTICAL_FLYING_SPEED
			get_parent().get_parent().stamina_bar_ui.value -=  Global.agnette_skill_multipliers["RavenFormFlightStaminaCost"]
		elif Input.is_action_pressed("ui_down"):
			get_parent().get_parent().velocity.y = VERTICAL_FLYING_SPEED
		else:
			get_parent().get_parent().velocity.y = 0
	
	if Global.current_character != "Agnette":
		if current_form == forms.BEAR:
			wild_shape(forms.ARCHER, forms.BEAR)
		elif current_form == forms.RAVEN:
			wild_shape(forms.ARCHER, forms.RAVEN)
		if attack_string_count != 4:
			attack_string_count = 4
			$ResetAttackStringTimer.stop()
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
		if current_form == forms.BEAR: 
			if event.is_action_pressed("ui_attack") and $BearFormNodes/BearInputPressTimer.is_stopped() and !is_charging:
				bear_attack()
				$BearFormNodes/BearInputPressTimer.start()
#			if event.is_action_pressed("primary_skill"):
#				if Global.agnette_talents["PrimalRegrowth"]["enabled"] and Global.agnette_talents["PrimalRegrowth"]["unlocked"]:
#					heal_in_wild_shape_form(forms.BEAR, 4)
		if current_form == forms.RAVEN and event.is_action_pressed("ui_attack") and $RavenFormNodes/RavenInputPressTimer.is_stopped() and !is_charging:
			raven_attack()
			$RavenFormNodes/RavenInputPressTimer.start()
		
		if event.is_action_pressed("heal"):
			if Global.healthpot_amount > 0:
				heal("Agnette", 5)
		if event.is_action_pressed("ui_dash") and !get_parent().get_parent().mobility_lock and $DashInputPressTimer.is_stopped():
			get_parent().get_parent().dash()
			if current_form == forms.RAVEN and Global.agnette_talents["StormyTempest"]["unlocked"] and Global.agnette_talents["StormyTempest"]["enabled"] and $TalentsNode2D/StormyTempestCDTimer.is_stopped():
				var tempest = RAVEN_TEMPEST.instance()
				get_parent().get_parent().get_parent().add_child(tempest)
				if !$AnimatedSprite.flip_h:
					tempest.direction = -1
				tempest.position = Vector2(global_position.x, global_position.y + 75)
				$TalentsNode2D/StormyTempestCDTimer.start()
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
		if current_form == forms.BEAR and event.is_action_pressed("ui_dash") and get_parent().get_parent().get_node("DashInputPressTimer").is_stopped():
#			if Global.agnette_talents["RoaringTrample"]["enabled"] and Global.agnette_talents["RoaringTrample"]["unlocked"]:
				get_parent().get_parent().dash()
		

func use_skill():
	if Global.current_character == "Agnette" and !is_charging and !get_parent().get_parent().is_frozen:
		if pskill_ui.value >= pskill_ui.max_value and Input.is_action_just_pressed("primary_skill") and current_form != forms.BEAR:
			use_primary_skill()
		if sskill_ui.value >= sskill_ui.max_value and Input.is_action_just_pressed("secondary_skill") and current_form != forms.RAVEN:
			use_secondary_skill()
		if Input.is_action_just_pressed("tertiary_skill"):
			use_tertiary_skill()

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
	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.agnette_skill_multipliers["RavenFormCost"]:
		emit_signal("skill_used", "RavenForm", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "RavenForm")
		emit_signal("mana_changed", Global.mana, "Agnette")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.agnette_skill_multipliers["RavenFormCost"]:
		emit_signal("skill_used", "RavenForm", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "RavenForm")
		emit_signal("mana_changed", Global.character2_mana, "Agnette")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.agnette_skill_multipliers["RavenFormCost"]:
		emit_signal("skill_used", "RavenForm", attack_buff)
		get_parent().get_parent().emit_signal("skill_ui_update", "RavenForm")
		emit_signal("mana_changed", Global.character3_mana, "Agnette")

func use_tertiary_skill():
	if Global.agnette_skill_multipliers["SpikeGrowthCharges"] > 0 and get_parent().get_parent().is_on_floor():
		Global.agnette_skill_multipliers["SpikeGrowthCharges"] -= 1
		emit_signal("update_spikegrowth_charges_ui", Global.agnette_skill_multipliers["SpikeGrowthCharges"])
		if !$AnimatedSprite.flip_h:
			emit_signal("skill_used", "SpikeGrowth", attack_buff, 1)
		else:
			emit_signal("skill_used", "SpikeGrowth", attack_buff, -1)
		get_parent().get_parent().emit_signal("skill_ui_update", "SpikeGrowth")
	


func wild_shape(target_form : int, previous_form : int = -1):
	current_form = target_form
	
	$WildShapeParticles.emitting = true
	match target_form:
		forms.ARCHER:
			is_wild_shaping = true
			$AnimatedSprite.visible = false
			$HurtAnimationPlayer.play("BeastDeath")
			$ChargedAttackBar.visible = true
			$AnimatedSprite.position = Vector2(0,0)
			$Area2D/CollisionShape2D.shape.extents = Vector2(45,54)
			$AnimatedSprite.scale = Vector2(5.25, 5.25)
			get_parent().get_parent().mobility_lock = false
			get_parent().get_parent().can_fly = false
			if previous_form == forms.BEAR:
				toggle_bear_form_snare(false)
				$BearFormNodes/BearHealthBar.visible = false
			$RavenFormNodes/RavenHealthBar.visible = false
			$BowSprite.visible = true
			$AnimatedSprite.stop()
			$AnimatedSprite.play("Default")
			$AnimatedSprite.visible = true
			is_wild_shaping = false
		forms.BEAR:
			is_wild_shaping = true
			$AnimatedSprite.visible = false
			$ChargedAttackBar.visible = false
			$AnimatedSprite.position = Vector2(0,-29)
			$Area2D/CollisionShape2D.shape.extents = Vector2(85,54)
			$AnimatedSprite.scale = Vector2(6,6)
			get_parent().get_parent().mobility_lock = true
			get_parent().get_parent().can_fly = false
			toggle_bear_form_snare(true)
			$BearFormNodes/BearHealthBar.max_value = Global.character_health_data["Agnette"] * (Global.agnette_skill_multipliers["BearFormHealth"] / 100)
			$BearFormNodes/BearHealthBar.value = $BearFormNodes/BearHealthBar.max_value
			$BearFormNodes/BearHealthBar.visible = true
			$RavenFormNodes/RavenHealthBar.visible = false
			$BowSprite.visible = false
			$AnimatedSprite.stop()
			$AnimatedSprite.play("BearDefault")
			$AnimatedSprite.visible = true
			is_wild_shaping = false
		forms.RAVEN:
			is_wild_shaping = true
			$AnimatedSprite.visible = false
			$ChargedAttackBar.visible = false
#			$AnimatedSprite.position = Vector2(0,-29)
			$Area2D/CollisionShape2D.shape.extents = Vector2(45,54)
			$AnimatedSprite.scale = Vector2(3.75,3.75)
			# enables the use of "ui_up" to fly up
			get_parent().get_parent().can_fly = true
			$RavenFormNodes/RavenHealthBar.max_value = Global.character_health_data["Agnette"] * (Global.agnette_skill_multipliers["RavenFormHealth"] / 100)
			$RavenFormNodes/RavenHealthBar.value = $RavenFormNodes/RavenHealthBar.max_value
			$RavenFormNodes/RavenHealthBar.visible = true
			if previous_form == forms.BEAR:
				toggle_bear_form_snare(false)
				$BearFormNodes/BearHealthBar.visible = false
			$BowSprite.visible = false
			$AnimatedSprite.stop()
			$AnimatedSprite.play("RavenDefault")
			$AnimatedSprite.visible = true
			is_wild_shaping = false

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

func toggle_bear_form_snare(active : bool):
	if active:
		$BearFormNodes/BearSelfSnareArea.remove_from_group("BearFormSnareOff")
		$BearFormNodes/BearSelfSnareArea.add_to_group("BearFormSnareOn")
		$BearFormNodes/BearSelfSnareArea/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(0.1), "timeout")
		$BearFormNodes/BearSelfSnareArea/CollisionShape2D.disabled = true
	else:
		$BearFormNodes/BearSelfSnareArea.remove_from_group("BearFormSnareOn")
		$BearFormNodes/BearSelfSnareArea.add_to_group("BearFormSnareOff")
		$BearFormNodes/BearSelfSnareArea/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(0.1), "timeout")
		$BearFormNodes/BearSelfSnareArea/CollisionShape2D.disabled = true

func charged_attack():
	# the arrow deals earth damage and builds earth trauma
	if $ShootTimer.is_stopped():
		if $ChargedAttackBar.value >= $ChargedAttackBar.max_value * 0.7:
			spawn_arrow($ChargedAttackBar.value, true)
			if Global.agnette_talents["VolleyShot"]["unlocked"] and Global.agnette_talents["VolleyShot"]["enabled"] and $TalentsNode2D/VolleyShootCooldownTimer.is_stopped():
				spawn_arrow($ChargedAttackBar.value * (Global.agnette_talents["VolleyShot"]["arrowdamagepercentage"] / 100), true, true, false)
				spawn_arrow($ChargedAttackBar.value * (Global.agnette_talents["VolleyShot"]["arrowdamagepercentage"] / 100), true, false, true)
				$TalentsNode2D/VolleyShootCooldownTimer.start()
			attack_string_count = 4
			
			
		else:
			spawn_arrow($ChargedAttackBar.value)
		$ShootTimer.start()

func charged_dash():
	$DashInputPressTimer.stop()
	# tendril go
	
		
func set_attack_power(type : String ,amount : float, duration : float, from_crystal : bool = true):
	if from_crystal:
		buffed_from_attack_crystals = true
	number_of_atk_buffs += 1
	
	var other_groups : Array
	prev_attack_power.insert((number_of_atk_buffs - 1),attack_buff )
	print(prev_attack_power)
	if type == "Flat":
		attack_buff = prev_attack_power[number_of_atk_buffs - 1] + amount
		set_attack_buff_value(attack_buff)
	elif type == "Percentage":
		attack_buff = prev_attack_power[number_of_atk_buffs - 1] + ((amount / 100) * Global.attack_power)
		set_attack_buff_value(attack_buff)
		
	print("Buffed: " + str(attack_buff))
	yield(get_tree().create_timer(duration), "timeout")
	attack_buff = prev_attack_power[number_of_atk_buffs - 1]
	set_attack_buff_value(attack_buff)
	print("DeBuffed: " + str(prev_attack_power[number_of_atk_buffs - 1]))
	number_of_atk_buffs -= 1
	prev_attack_power.remove(number_of_atk_buffs)
	if from_crystal:
		buffed_from_attack_crystals = false
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


func spawn_arrow(charge_value : int = 0, earth_damage : bool = false, is_up : bool = false, is_down : bool = false):
	var charged_bonus : float = 1 + (1.25 * charge_value / 100)
#	print("charge value: " + str(charge_value))
	if charge_value >= 50:
		charged_bonus = 1.35 + (2.25 * charge_value / 100)
	var crit_dmg : float = 1.0
	var arrow = ARROW.instance()
	
#
	get_parent().get_parent().get_parent().add_child(arrow)
	if earth_damage:
		arrow.get_node("Area2D").remove_from_group("Sword")
		arrow.get_node("Area2D").add_to_group("Earth")
	if is_a_critical_hit():
		crit_dmg = (Global.agnette_skill_multipliers["CritDamage"] / 100 + 1)
		arrow.get_node("Area2D").add_to_group("IsCritHit")
	else:
		arrow.get_node("Area2D").remove_from_group("IsCritHit")
	if is_up:
		arrow.up = true
	elif is_down:
		arrow.down = true
	var mult : int = 4 - attack_string_count + 1
	arrow.get_node("Area2D").add_to_group(str(charged_bonus * ATTACK * (Global.agnette_skill_multipliers["Arrow" + str(mult)] / 100) * crit_dmg))
	
	if !$AnimatedSprite.flip_h:
		arrow.position.x = global_position.x + 40
		arrow.position.y = global_position.y
	else:
		arrow.position.x = global_position.x - 40
		arrow.position.y = global_position.y
		arrow.x_direction = -1
#	print("atk string: " + str(attack_string_count))
	attack_string_count -= 1
	attack_string_count = clamp(attack_string_count, 0, 4)
	if attack_string_count == 0:
		attack_string_count = 4

func spread_shot_arrow():
	pass

func bear_attack():
	if Global.current_character == "Agnette" and $BearFormNodes/BearAttackDelayTimer.is_stopped():
		for groups in $BearFormNodes/AttackCollision.get_groups():
			if float(groups) != 0:
				$BearFormNodes/AttackCollision.remove_from_group(groups)
				$BearFormNodes/AttackCollision.add_to_group(str((ATTACK * (Global.agnette_skill_multipliers["BearFormAttack1"] / 100) + basic_attack_buff)))
		$BearFormNodes/AttackCollision/CollisionShape2D.disabled = false
		bear_is_attacking = true
		$AnimatedSprite.play("BearJump")
		if !$AnimatedSprite.flip_h:
			$BearFormNodes/BearAttackAnimationPlayer.play("BearAttack1Right")
		else:
			$BearFormNodes/BearAttackAnimationPlayer.play("BearAttack1Left")
		$BearFormNodes/BearAttackDelayTimer.start()
		$BearFormNodes/AttackTimer.start()
		yield(get_tree().create_timer(0.5), "timeout")
		bear_is_attacking = false
#		$AnimatedSprite.play("BearDefault")

func bear_charged_attack():
	$BearFormNodes/BearInputPressTimer.stop()
	var shockwave = preload("res://scenes/enemies/bosses/Shockwave.tscn").instance()
	get_parent().get_parent().get_parent().add_child(shockwave)
	if $AnimatedSprite.flip_h:
		shockwave.direction = -1
	shockwave.position = global_position

func raven_attack():
	if Global.current_character == "Agnette" and $RavenFormNodes/RavenAttackDelayTimer.is_stopped():
		for groups in $RavenFormNodes/AttackCollision.get_groups():
			if float(groups) != 0:
				$RavenFormNodes/AttackCollision.remove_from_group(groups)
				$RavenFormNodes/AttackCollision.add_to_group(str((ATTACK * (Global.agnette_skill_multipliers["RavenFormPeckAttack"] / 100) + basic_attack_buff)))
		$RavenFormNodes/AttackCollision/CollisionShape2D.disabled = false
		raven_is_attacking = true
#		$AnimatedSprite.play("BearJump")
		if !$AnimatedSprite.flip_h:
			$RavenFormNodes/RavenAttackAnimationPlayer.play("RavenPeckAttackRight")
		else:
			$RavenFormNodes/RavenAttackAnimationPlayer.play("RavenPeckAttackLeft")
		$RavenFormNodes/RavenAttackDelayTimer.start()
		$RavenFormNodes/AttackTimer.start()
		yield(get_tree().create_timer(0.5), "timeout")
		raven_is_attacking = false

func raven_charged_attack():
	$RavenFormNodes/RavenInputPressTimer.stop()
	var rp = RAVEN_PROJECTILE.instance()
	get_parent().get_parent().get_parent().add_child(rp)
	rp.position = global_position


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
	
func heal(character : String = "Agnette", heal_amount : float = 0, heal_to_max : bool = false, consumes_potion : bool = true):
	if Global.equipped_characters[0] == character:
		if !heal_to_max:
			add_heal_particles(clamp(heal_amount, 0, Global.max_hearts - Global.hearts))
			Global.hearts += clamp(heal_amount, 0, Global.max_hearts - Global.hearts)
		else:
			add_heal_particles(Global.max_hearts - Global.hearts)
			Global.hearts = Global.max_hearts
		emit_signal("life_changed", Global.hearts, character)
	elif Global.equipped_characters[1] == character:
		if !heal_to_max:
			add_heal_particles(clamp(heal_amount, 0, Global.character_2_max_hearts - Global.character2_hearts))
			Global.character2_hearts += clamp(heal_amount, 0, Global.character_2_max_hearts - Global.character2_hearts)
		else:
			add_heal_particles(Global.character_2_max_hearts - Global.character2_hearts)
			Global.character2_hearts = Global.character_2_max_hearts
		emit_signal("life_changed", Global.character2_hearts, character)
	elif Global.equipped_characters[2] == character:
		if !heal_to_max:
			add_heal_particles(clamp(heal_amount, 0, Global.character_3_max_hearts - Global.character3_hearts))
			Global.character3_hearts += clamp(heal_amount, 0, Global.character_3_max_hearts - Global.character3_hearts)
		else:
			add_heal_particles(Global.character_3_max_hearts - Global.character3_hearts)
			Global.character3_hearts = Global.character_3_max_hearts
		emit_signal("life_changed", Global.character3_hearts, character)
		
	if !heal_to_max and consumes_potion:
		Global.healthpot_amount -= 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)
	

func heal_in_wild_shape_form(form : int, heal_amount : float = 0):
	match form:
		forms.BEAR:
			add_heal_particles(clamp(heal_amount, 0, $BearFormNodes/BearHealthBar.max_value - $BearFormNodes/BearHealthBar.value))
			$BearFormNodes/BearHealthBar.value += heal_amount
			





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
		




	





func _on_Area2D_area_entered(area):
	if area.is_in_group("AgnetteChargedAttackSnareOn"):
		var slowdown_coefficient : float = Global.agnette_skill_multipliers["ChargedAttackMovementSpeedPenalty"] / 100
		get_parent().get_parent().SPEED -= get_parent().get_parent().MAX_SPEED * slowdown_coefficient
	if area.is_in_group("AgnetteChargedAttackSnareOff"):
		var slowdown_coefficient : float = Global.agnette_skill_multipliers["ChargedAttackMovementSpeedPenalty"] / 100
		get_parent().get_parent().SPEED += get_parent().get_parent().MAX_SPEED * slowdown_coefficient
	if area.is_in_group("BearFormSnareOn"):
		var slowdown_coefficient : float = Global.agnette_skill_multipliers["BearFormMovementSpeedPenalty"] / 100
		get_parent().get_parent().SPEED -= get_parent().get_parent().MAX_SPEED * slowdown_coefficient
	if area.is_in_group("BearFormSnareOff"):
		var slowdown_coefficient : float = Global.agnette_skill_multipliers["BearFormMovementSpeedPenalty"] / 100
		get_parent().get_parent().SPEED += get_parent().get_parent().MAX_SPEED * slowdown_coefficient
	if Global.current_character == "Agnette":
		if area.is_in_group("HealthPot"):
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		if area.is_in_group("LifeWine"):
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		if area.is_in_group("AddMana"):
			change_mana_value(area.get_parent().mana_granted)
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
					if current_form != forms.BEAR and !area.is_in_group("LightEnemy") or !get_parent().get_parent().resist_interruption:
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
		if area.is_in_group("Weaken") and $WeakenedTimer.is_stopped():
			atkbuffmulti = area.amount
			atkbuffdur = area.duration
			set_attack_power(area.type, float(atkbuffmulti), float(atkbuffdur), false)
			$WeakenedTimer.wait_time = area.duration
			$WeakenedTimer.start()
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
		if Global.character2_hearts <= 0:
			dead(Global.equipped_characters[1])
	elif Global.equipped_characters[2] == Global.current_character:
		if Global.character3_hearts <= 0:
			dead(Global.equipped_characters[2])

func dead(character_id):
	
	is_dead = true
	get_parent().get_parent().is_invulnerable = true
	$InvulnerabilityTimer.start()
#	get_parent().get_parent().swap_to_nearby_alive_characters()
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

func swap_to_nearby_alive_characters():
	get_parent().get_parent().swap_to_nearby_alive_characters()
	
func round_to_dec(num, digit) -> float:
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func add_hurt_particles(damage : float):
	var hurt_particle = get_parent().get_parent().HURT_PARTICLE.instance()
	hurt_particle.damage = round_to_dec(damage * 2, 2)
	get_parent().get_parent().get_parent().add_child(hurt_particle)
	hurt_particle.position = global_position

func take_damage(damage : float):
	var def = Global.character_defense_data["Agnette"] / 100
	var stoneskin_mult : float = 1
	if is_charging and Global.agnette_talents["Stoneskin"]["unlocked"] and Global.agnette_talents["Stoneskin"]["enabled"]:
		stoneskin_mult -= Global.agnette_talents["Stoneskin"]["damagereduction"] / 100

	if Global.current_character == "Agnette":
		if current_form == forms.ARCHER:
			if Global.equipped_characters[0] == "Agnette":
				if get_parent().get_parent().shield_hp > 0:
					get_parent().get_parent().shield_hp = clamp(get_parent().get_parent().shield_hp - damage, 0, 999)
					get_parent().get_parent().get_node("Shield/ShieldHPBar").value = get_parent().get_parent().shield_hp
				else:
					Global.hearts -= stoneskin_mult * damage * (1 - def)
					add_hurt_particles(stoneskin_mult * damage * (1 - def))
					emit_signal("life_changed", Global.hearts, "Agnette")
			elif Global.equipped_characters[1] == "Agnette":
				if get_parent().get_parent().shield_hp > 0:
					get_parent().get_parent().shield_hp = clamp(get_parent().get_parent().shield_hp - damage, 0, 999)
					get_parent().get_parent().get_node("Shield/ShieldHPBar").value = get_parent().get_parent().shield_hp
				else:
					Global.character2_hearts -= stoneskin_mult * damage * (1 - def)
					add_hurt_particles(stoneskin_mult * damage * (1 - def) )
					emit_signal("life_changed", Global.character2_hearts, "Agnette")
			elif Global.equipped_characters[2] == "Agnette":
				if get_parent().get_parent().shield_hp > 0:
					get_parent().get_parent().shield_hp = clamp(get_parent().get_parent().shield_hp - damage, 0, 999)
					get_parent().get_parent().get_node("Shield/ShieldHPBar").value = get_parent().get_parent().shield_hp
				else:
					Global.character3_hearts -= stoneskin_mult * damage * (1 - def)
					add_hurt_particles(stoneskin_mult * damage * (1 - def))
					emit_signal("life_changed", Global.character3_hearts, "Agnette")
		elif current_form == forms.BEAR:
			
			$BearFormNodes/BearHealthBar.value -= damage
			add_hurt_particles(damage)
			if $BearFormNodes/BearHealthBar.value <= $BearFormNodes/BearHealthBar.min_value:
				$HurtAnimationPlayer.play("BeastDeath")
#				yield(get_tree().create_timer(0.4), "timeout")
				wild_shape(forms.ARCHER, forms.BEAR)
		elif current_form == forms.RAVEN:
			$RavenFormNodes/RavenHealthBar.value -= damage
			add_hurt_particles(damage)
			if $RavenFormNodes/RavenHealthBar.value <= $RavenFormNodes/RavenHealthBar.min_value:
				$HurtAnimationPlayer.play("BeastDeath")
#				yield(get_tree().create_timer(0.4), "timeout")
				wild_shape(forms.ARCHER, forms.RAVEN)
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
				var arrow_rain = RAIN_OF_ARROWS.instance()
				arrow_rain.get_node("Area2D").add_to_group(str(ATTACK * (Global.agnette_skill_multipliers["RainOfArrows"] / 100)))
				get_parent().get_parent().get_parent().add_child(arrow_rain)
				if !$AnimatedSprite.flip_h:
					arrow_rain.position = Vector2(global_position.x + 200, global_position.y - 130)
				else:
					arrow_rain.position = Vector2(global_position.x - 200, global_position.y - 130)
					
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
	if Global.current_character == "Agnette" and !get_parent().get_parent().mobility_lock and Input.is_action_pressed("ui_dash") and !Input.is_action_pressed("ui_attack"):
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
		wild_shape(forms.ARCHER, forms.BEAR)


func _on_AttackTimer_timeout():
	$BearFormNodes/AttackCollision/CollisionShape2D.disabled = true


func _on_BearInputPressTimer_timeout():
	if Input.is_action_pressed("ui_attack") and current_form == forms.BEAR:
		bear_charged_attack()

func _on_RavenInputPressTimer_timeout():
	if Input.is_action_pressed("ui_attack") and current_form == forms.RAVEN:
		raven_charged_attack()

func _on_RavenAttackCollision_area_entered(area):
	pass # Replace with function body.


func _on_RavenAttackCollision_area_exited(area):
	pass # Replace with function body.


func _on_RavenFormDurationTimer_timeout():
	if current_form == forms.RAVEN:
		wild_shape(forms.ARCHER, forms.RAVEN)


func _on_RavenAttackTimer_timeout():
	$RavenFormNodes/AttackCollision/CollisionShape2D.disabled = true
