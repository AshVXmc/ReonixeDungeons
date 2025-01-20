class_name Player extends KinematicBody2D

signal life_changed(player_hearts)
signal mana_changed(player_mana)
signal healthpot_obtained(player_healthpot)
signal lifewine_obtained(player_lifewine)
signal manapot_obtained(player_manapot)
signal opals_obtained(player_opals, amount_added)
signal crystals_obtained(player_crystals)
signal record_opals_obtained(amount)
signal ingredient_obtained(ingredient_name, amount)
signal skill_used(skill_name, character)
signal skill_ui_update()
signal perfect_dash()
signal action(action_type)
signal trigger_quickswap(trigger_name)
signal ready_to_be_switched_in(character)
signal change_elegance(action_name)
signal change_hitcount(amount)
signal force_character_swap(index)
signal reduce_skill_cd(character_name, skill_type, amount_in_seconds)
signal reduce_endurance(amount)
signal update_fireball_charges_ui(charges)
var target 

var can_use_slash_flurry : bool = false
var attack_area_overlaps_enemy : bool 
var resist_interruption : bool = false
const TEMPUS_TARGUS : PackedScene = preload("res://scenes/misc/TempusTardus.tscn")
const DEATH_SMOKE_PARTICLE = preload("res://scenes/particles/DeathSmokeParticle.tscn")
# Attack buff 
var atkbuffmulti = 0
var atkbuffdur = 0
var basicatkbuffmulti = 0
var basicatkbuffdur = 0
var is_doing_charged_attack : bool = false
# Attack buff for all abilities (Skills)
var atkbuffskill = 0
var buffed_from_attack_crystals = false
var prev_basic_attack_power : Array 
var prev_attack_power : Array 
var prev_charged_attack_power : Array
var number_of_atk_buffs : int = 0
var number_of_charged_atk_buffs : int = 0
var number_of_basic_atk_buffs : int = 0
var move_speed_multiplier : float = 1
onready var inv_timer : Timer = $InvulnerabilityTimer
onready var fb_timer : Timer = $FireballTimer
var knockdir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2(0,0)
var healthpot_amount : int = Global.healthpot_amount
var collision : KinematicCollision2D
const TYPE : String = "Player"
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
var dashdirection : Vector2 = Vector2(1,0)

var knockback_power : int = 800
var can_be_knocked : bool = true
const MAX_SPEED : int = 350
var SPEED : int = MAX_SPEED
const GRAVITY : int = 38
var JUMP_POWER : int = -810 # for double jumping
var can_double_jump : bool = true
var waiting_for_quickswap : bool = false
var is_thrust_attacking : bool = false
var energy_full : bool 
var is_dash_counter_attacking : bool = false
var facing 
var is_switch_in_attacking : bool = false
var is_counter_attack_special_thrusting : bool = false
var is_jumping : bool = false
enum {
	left, right
}
const TRAIL_PARTICLE = preload("res://scenes/particles/DashTrailParticle.tscn")
const WALK_PARTICLE = preload("res://scenes/particles/WalkParticle.tscn")
const TELEPORTING_PARTICLE = preload("res://scenes/particles/TeleportingParticles.tscn")
const KATANA = preload("res://assets/characters/player/katana.png")
const SHEATHED = preload("res://assets/characters/player/katana_sheath.png")
const EMPTY_SHEATH = preload("res://assets/characters/player/katana_sheath_empty.png")
const KATANA_CYBERNINJA = preload("res://assets/characters/player/skins/cyber_ninja/katana.png")
const SHEATHED_CYBERNINJA = preload("res://assets/characters/player/skins/cyber_ninja/katana_sheath.png")
const EMPTY_SHEATH_CYBERNINJA = preload("res://assets/characters/player/skins/cyber_ninja/katana_sheath_empty.png")
const PIERCING_PROJECTILE = preload("res://scenes/skills/PiercingProjectile.tscn")
const SLASH_FLURRY_AREA = preload("res://scenes/skills/SlashFlurryMovableArea.tscn")
const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const HURT_PARTICLE : PackedScene = preload("res://scenes/particles/HurtIndicatorParticle.tscn")
const HEAL_PARTICLE : PackedScene = preload("res://scenes/particles/HealIndicatorParticle.tscn")
const JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/JumpParticle.tscn")
const STRONG_JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/StrongJumpParticle.tscn")
const WATER_JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/WaterBubbleParticle.tscn")
const DASH_PARTICLE : PackedScene = preload("res://scenes/particles/DashParticle.tscn")
const SWORD_PARTICLE : PackedScene = preload("res://scenes/particles/SwordSwingParticle.tscn")
const GLACIELA_PUPPET : PackedScene = preload("res://scenes/characters/GlacielaPuppet.tscn")
const GROUND_POUND_PARTICLE : PackedScene = preload("res://scenes/particles/GroundPoundParticle.tscn")
const SUPER_SLASH_PROJECTILE : PackedScene = preload("res://scenes/misc/SuperSlashProjectile.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const FROZEN : PackedScene = preload("res://scenes/status_effects/FrozenStatus.tscn")
const MAXED_ENERGY_METER = preload("res://assets/UI/energy_meter_maxed.png")
const ENERGY_METER = preload("res://assets/UI/energy_meter_partly_filled.png")
const BURNING : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
const BURNING_BREATH_TALENT : PackedScene = preload("res://scenes/particles/BurningBreathTalent.tscn")
var burning_breath_timer 
onready var FULL_CHARGE_METER = preload("res://assets/UI/chargebar_full.png")
onready var CHARGING_CHARGE_METER = preload("res://assets/UI/chargebar_charging.png")
const DASH_STAMINA_COST : int = 100
const DOUBLE_JUMP_STAMINA_COST : int = 100
const DEFAULT_SKIN = preload("res://spriteframes/Player_Default_spriteframes.tres")
const CYBER_NINJA_SKIN = preload("res://spriteframes/Player_CyberNinja_spriteframes.tres")
const WHITE_MAGE_SKIN = preload("res://spriteframes/Player_WhiteMage_spriteframes.tres")
var is_attacking : bool = false
var is_dead : bool = false
var is_invulnerable : bool = false
var is_knocked_back : bool = false
var collided : bool = false
var is_dashing : bool = false
var is_gliding : bool = false
var can_dash : bool = false
var is_healing : bool = false
var is_shopping : bool = false
var is_frozen : bool = false
var can_fly : bool = false
const VERTICAL_FLYING_SPEED : int = 300
var is_using_primary_skill : bool = false
var is_using_secondary_skill : bool = false
var glider_equipped : bool = false
var is_ground_pounding : bool = false
var cam_shake : bool = false
var is_charging : bool = false
var slowed : bool = false
var underwater : bool = false
var airborne_mode : bool = false
var mana_absorption_counter_max : int = 3
var mana_absorption_counter : int = mana_absorption_counter_max
var restore_mana_for_all_parties : int = 2
var ATTACK : float = Global.attack_power
var attack_buff : float setget set_attack_buff_value
var basic_attack_buff : float
var charged_attack_buff : float 
var attack_string_count : int = 4
var perfect_dash : bool = false
var perfect_charged_attack : bool = false
var is_quickswap_attacking : bool = false
var is_flurry_attacking : bool = false
var is_sheathing : bool = false
var phys_res : float = Global.player_skill_multipliers["BasePhysRes"]
var magic_res : float = Global.player_skill_multipliers["BaseMagicRes"]
var fire_res : float = Global.player_skill_multipliers["BaseFireRes"]
var ice_res : float = Global.player_skill_multipliers["BaseIceRes"]
var earth_res : float = Global.player_skill_multipliers["BaseEarthRes"]
# amount of damage that a shield can absorb
var shield_hp : float
var is_in_immortality_field : bool = false
onready var basic_attack_power : float = Global.attack_power * (Global.player_skill_multipliers["BasicAttack"] / 100)
onready var charged_attack_power : float = Global.attack_power * (Global.player_skill_multipliers["ChargedAttack"] / 100)
onready var upwards_and_downwards_charged_attack_power :float = Global.attack_power * (Global.player_skill_multipliers["UpwardsChargedAttack"] / 100)
onready var airborne_charged_attack_power :float = Global.attack_power * (Global.player_skill_multipliers["SpecialChargedAttack"] / 100)
onready var thrust_attack_power :float = Global.attack_power * (Global.player_skill_multipliers["ThrustChargedAttack"] / 100)
onready var pskill_ui : TextureProgress = get_parent().get_node("SkillsUI/Control/PrimarySkill/Player/FireSaw/TextureProgress")
onready var sskill_ui : TextureProgress =  get_parent().get_node("SkillsUI/Control/SecondarySkill/Player/FireFairy/TextureProgress")
onready var tskill_ui : TextureProgress = get_parent().get_node("SkillsUI/Control/TertiarySkill/Player/Fireball/TextureProgress")
onready var perkskill_ui : TextureProgress 
onready var chaos_magic : PackedScene = preload("res://scenes/menus/ChaosMagicUI.tscn")
onready var stamina_bar_ui : TextureProgress = get_parent().get_node("StaminaBarUI/StaminaBarUI/TextureProgress")
onready var crit_rate : float = Global.player_skill_multipliers["CritRate"]
onready var crit_damage : float = Global.player_skill_multipliers["CritDamage"]
# when a flash appears after the 3rd string of basic attack, tap to thrust through enemies
# this can be broken if enemy hits you first

# if this TRUE, the player wont be able to jump or dash
# used in agnette's bear form
var mobility_lock : bool = false

func move_sheath(node_name : String, layer : int):
	move_child(get_node(node_name), layer)

func set_attack_buff_value(new_value):
	attack_buff = new_value
	ATTACK = Global.attack_power + attack_buff

func _ready():
	
#	print(get_path())
	if Global.current_character == "Player":
		$Sprite.visible = true
	update_perk_skill()
	change_skin(Global.equipped_character_skins["Player"])

#	perkskill_ui = get_parent().get_node("SkillsUI/Control/PerkSkill/Player/CreateSugarRoll/TextureProgress")
	$TalentsNode2D/BurningBreathCDTimer.wait_time = Global.player_talents["BurningBreath"]["cooldown"]
	
	$EnergyMeter.visible = false
#	$EnergyMeter.value = $EnergyMeter.min_value

	$SlashEffectSprite.visible = false
	$AttackCollision.add_to_group(str(basic_attack_power))
	$SwordSprite.flip_v = false
	$ChargedAttackCollision.add_to_group(str(charged_attack_power))
	$UpwardsChargedAttackCollision.add_to_group(str(upwards_and_downwards_charged_attack_power))
	$DownwardsChargedAttackCollision.add_to_group(str(upwards_and_downwards_charged_attack_power))
	$SuperSlashProjectile2.visible  = false
	$ThrustEffectArea.add_to_group(str(thrust_attack_power))
	$OxygenBar.value = 100
	$ChargeBar.value = 0
	$SwordSprite.visible = false
	$ChargeBar.visible = false
	$FireCharmTimer.wait_time = Global.player_skill_multipliers["FireCharmCD"]
	connect("force_character_swap", get_node("CharacterManager"), "swap_character")
	connect("change_elegance", get_parent().get_node("EleganceMeterUI/Control"), "elegance_changed")
	connect("change_hitcount", get_parent().get_node("EleganceMeterUI/Control"), "hitcount_changed")
	connect("ready_to_be_switched_in", get_parent().get_node("SkillsUI/Control"), "flicker_icon")
	connect("action", Global, "parse_action")
	connect("reduce_endurance", get_parent().get_node("SkillsUI/Control"), "reduce_endurance")
	connect("update_fireball_charges_ui", get_parent().get_node("SkillsUI/Control"), "update_fireball_skill_ui")
	connect("perfect_dash", get_parent().get_node("PauseUI/PerfectDash"), "trigger_perfect_dash_animation")
	connect("ingredient_obtained", get_parent().get_node("InventoryUI/Control"), "on_ingredient_obtained")
#	emit_signal("ingredient_obtained", "common_dust", Global.common_monster_dust_amount)
#	emit_signal("ingredient_obtained", "goblin_scales", Global.goblin_scales_amount)
	
	connect("skill_ui_update", get_parent().get_node("SkillsUI/Control"), "on_skill_used")
	connect("skill_used", get_node("SkillManager"), "on_skill_used")
	
	connect("reduce_skill_cd", get_parent().get_node("SkillsUI/Control"), "reduce_skill_cooldown")
# warning-ignore:return_value_discarded
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
# warning-ignore:return_value_discarded
	connect("mana_changed", get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", get_parent().get_node("LifeWineUI/LifeWineControl"), "on_player_lifewine_obtained")
# warning-ignore:return_value_discarded
	connect("manapot_obtained", get_parent().get_node("ManaPotUI/ManaPotControl"), "on_player_manapot_obtained")
# warning-ignore:return_value_discarded
	connect("opals_obtained", get_parent().get_node("OpalsUI/OpalsControl"), "on_player_opals_obtained")
	connect("record_opals_obtained", get_parent().get_node("LevelTransporterEnd"), "record_opals_obtained")
# warning-ignore:return_value_discarded
	connect("crystals_obtained", get_parent().get_node("RevivementCrystal/RevivementCrystalControl"), "on_player_crystal_obtained")
	connect("life_changed", Global, "sync_hearts")
#	emit_signal("life_changed", Global.hearts)
# warning-ignore:return_value_discarded
	connect("mana_changed", Global, "sync_mana")
	if Global.equipped_characters == [0]:
		emit_signal("mana_changed", Global.mana)
	elif Global.equipped_characters == [1]:
		emit_signal("mana_changed", Global.character2_mana)
	elif Global.equipped_characters == [2]:
		emit_signal("mana_changed", Global.character3_mana)
	
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", Global, "sync_playerHealthpots")
	emit_signal("healthpot_obtained", Global.healthpot_amount)
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", Global, "sync_playerLifeWines")
	emit_signal("lifewine_obtained", Global.lifewine_amount)
# warning-ignore:return_value_discarded
	connect("manapot_obtained", Global, "sync_playerManapots")
	emit_signal("manapot_obtained", Global.manapot_amount)
# warning-ignore:return_value_discarded
	connect("opals_obtained", Global, "sync_playerOpals")
	emit_signal("opals_obtained", Global.opals_amount)
# warning-ignore:return_value_discarded
	connect("crystals_obtained", Global, "sync_playerCrystals")
	emit_signal("crystals_obtained", Global.crystals_amount)
	
	
#	connect("common_monster_dust_obtained", Global, "sync_playerCommonMonsterDust")
#	emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
#
#	connect("goblin_scales_obtained", Global, "sync_playerGoblinScales")
#	emit_signal("goblin_scales_obtained", Global.goblin_scales_amount)

func update_perk_skill():
	Global.player_perks[Global.player_skills["PerkSkill"]]["enabled"] = true
	for i in Global.player_perks.keys():
		if i != Global.player_skills["PerkSkill"]:
			Global.player_perks[i]["enabled"] = false

	
	if Global.player_perks["CreateSugarRoll"]["enabled"]:
		print("PERK WENT ON")
		perkskill_ui = get_parent().get_node("SkillsUI/Control/PerkSkill/Player/CreateSugarRoll/TextureProgress")
		if has_node("ChaosMagicUI"):
			get_node("ChaosMagicUI").call_deferred('free')
	elif Global.player_perks["ChaosMagic"]["enabled"]:
		perkskill_ui = get_parent().get_node("SkillsUI/Control/PerkSkill/Player/ChaosMagic/TextureProgress")
		if !has_node("ChaosMagicUI"):
			add_child(chaos_magic.instance())
		
func change_skin(skin_name : String):
	match skin_name:
		"DEFAULT_SKIN":
			$Sprite.frames = DEFAULT_SKIN
			$SwordSprite.texture = KATANA
			$KatanaSheathSprite.texture = SHEATHED
			$Sprite.scale.x = 5
			$Sprite.scale.y = 5
			$Sprite.position.y = 0
		"WHITE_MAGE_SKIN":
			$Sprite.frames = WHITE_MAGE_SKIN
			$SwordSprite.texture = KATANA
			$KatanaSheathSprite.texture = SHEATHED
			$Sprite.scale.x = 5
			$Sprite.scale.y = 5
			$Sprite.position.y = 0
		"CYBER_NINJA_SKIN":
			$Sprite.frames = CYBER_NINJA_SKIN
			$SwordSprite.texture = KATANA_CYBERNINJA
			$KatanaSheathSprite.texture = SHEATHED_CYBERNINJA
			$Sprite.scale.x = 6
			$Sprite.scale.y = 6
			$Sprite.position.y = -10
	Global.equipped_character_skins["Player"] = skin_name
func quickswap_event(trigger_name : String):
	match trigger_name:
		"Glaciela":
			waiting_for_quickswap = true
			

# Trigger when player is switched in
func switched_in(character):
	if character == "Player":
		$EnergyMeter.visible = true
		$HideEnergyMeterTimer.start()
		if waiting_for_quickswap:
			print("SWITCH in ATTACK")
			switch_in_attack()
			waiting_for_quickswap = false

# WOO YEAH BABY
func quickswap_attack(trigger_name : String = ""):
	match trigger_name:
		"Glaciela":
			var gp = GLACIELA_PUPPET.instance()
			get_parent().add_child(gp)
			gp.position = global_position
			print("QUICKSWAP TRIGGERED")
	

func get_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy
	
func _physics_process(_delta):
	
#	if Global.current_character == "Player":
#		$EnergyMeter.visible = true
#	else:
#		$EnergyMeter.visible = false
	if Global.current_character != "Player":
		$EnergyMeter.visible = false
#	if !is_sheathing:
	if !$Sprite.flip_h:
		$KatanaSheathPlayer.play("RightDefault")
	else:
		$KatanaSheathPlayer.play("LeftDefault")

	$Shield.visible = true if shield_hp > 0 else false
#	if Input.is_action_just_pressed("slot_1"):
#		if facing == left:
#			facing = right
#		elif facing == right:
#			facing = left
	# Makes sure the player is alive to use any movement controls
	if !is_dead or Global.current_character != "Player":
		if !is_invulnerable and !is_healing and !is_shopping and !is_frozen:
			$KatanaSheathSprite.visible = true if Global.current_character == "Player" else false
			target = get_closest_enemy()
			# Function calls
			if !is_charging:
#				if can_fly:
#					glide()
				useItems()
				use_skill()
				if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") and attack_string_count != 3:
					attack_string_count = 4
				# Movement controls
				if velocity.x == 0 and !is_attacking and !is_gliding and !is_frozen:
					$Sprite.play("Idle")
				if Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !is_attacking and !is_dashing and !is_knocked_back:
					facing = left
				elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !is_attacking and !is_knocked_back and !is_dashing:
					facing = right
				else:
					facing = null 
				if !is_doing_charged_attack:
					if facing == left:
						velocity.x = -SPEED
						Input.action_release("right")
#						attack_string_count = 4
						mana_absorption_counter = mana_absorption_counter_max
	#					$AirborneMaxDuration.start()
	#					airborne_mode = false
#						$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
						$Sprite.flip_h = true
						if velocity.x == 0 and !is_attacking and !is_gliding:
							$Sprite.play("Idle")
						if sign($Position2D.position.x) == 1:
							$Position2D.position.x *= -1
						if sign($DashParticlePosition.position.x) == -1:
							$DashParticlePosition.position.x *= -1
						if Input.is_action_just_released("left"):
							$Sprite.play("Walk")
						$AttackCollision.set_scale(Vector2(-1,1))
						$SwitchAttackCollision.set_scale(Vector2(-1,1))
						$StabAttackCollision.set_scale(Vector2(-1,1))
						$ChargedAttackCollision.set_scale(Vector2(-1,1))
						$ChargedAttackDetector.set_scale(Vector2(-1,1))
						$UpwardsChargedAttackCollision.set_scale(Vector2(-1,1))
						$DownwardsChargedAttackCollision.set_scale(Vector2(-1,1))
						$EnemyEvasionArea.set_scale(Vector2(-1,1))
						
					elif facing == right:
						Input.action_release("left")
#						attack_string_count = 4
						mana_absorption_counter = mana_absorption_counter_max
						velocity.x = SPEED
	#					$AirborneMaxDuration.start()
	#					airborne_mode = false
					# warning-ignore:standalone_ternary
#						$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
						$Sprite.flip_h = false
						if velocity.x == 0 and !is_attacking and is_gliding:
							$Sprite.play("Idle")
						if sign($Position2D.position.x) == -1:
							$Position2D.position.x *= -1
						if sign($DashParticlePosition.position.x) == 1:
							$DashParticlePosition.position.x *= -1
						if Input.is_action_just_released("right"):
							$Sprite.play("Walk")
							
						$AttackCollision.set_scale(Vector2(1,1))
						$ChargedAttackCollision.set_scale(Vector2(1,1))
						$ChargedAttackDetector.set_scale(Vector2(1,1))
						$SwitchAttackCollision.set_scale(Vector2(1,1))
						$StabAttackCollision.set_scale(Vector2(1,1))
						$UpwardsChargedAttackCollision.set_scale(Vector2(1,1))
						$DownwardsChargedAttackCollision.set_scale(Vector2(1,1))
						$EnemyEvasionArea.set_scale(Vector2(1,1))
				
					# Jump controls (ground)
					if Input.is_action_just_pressed("jump") and !can_fly and !mobility_lock and !is_attacking and !is_frozen and !underwater and !Input.is_action_pressed("ui_dash"):
						if can_double_jump or is_on_floor():
							if !is_on_floor() and stamina_bar_ui.value >= DOUBLE_JUMP_STAMINA_COST: 
								can_double_jump = false
								stamina_bar_ui.value -= DOUBLE_JUMP_STAMINA_COST
							$DashAfterJumpingDelayTimer.start()
							# Particles
							var jump_particle : JumpParticle = JUMP_PARTICLE.instance()
							jump_particle.emitting = true
							get_parent().add_child(jump_particle)
							jump_particle.position = $ParticlePosition.global_position
#							if can_fly:
#								velocity.y = JUMP_POWER * 1.2
#							else:
							velocity.y = JUMP_POWER
							is_jumping = true
							$Sprite.play("Idle")
							yield(get_tree().create_timer(0.2), "timeout")
							var trail_particle = TRAIL_PARTICLE.instance()
							trail_particle.emitting = true
							trail_particle.one_shot = true
							get_parent().add_child(trail_particle)
							trail_particle.position = $ParticlePosition.global_position
					# Jump controls (water)
					if Input.is_action_just_pressed("jump") and underwater and !is_attacking and !is_frozen:
						var water_jump_particle = WATER_JUMP_PARTICLE.instance()
						water_jump_particle.emitting = true
						get_parent().add_child(water_jump_particle)
						water_jump_particle.position = $ParticlePosition.global_position
						velocity.y = JUMP_POWER / 1.5
						$Sprite.play("Idle")
					
	#				is_attacking = false
					
				# Movement calculations
	#			if !is_dashing and !is_gliding:
	#				velocity.y += GRAVITY
				if can_fly:
					if Input.is_action_pressed("ui_up") or Input.is_action_pressed("jump"):
						velocity.y = -VERTICAL_FLYING_SPEED
					elif Input.is_action_pressed("ui_down"):
						velocity.y = VERTICAL_FLYING_SPEED
					else:
						velocity.y = 0
				if is_jumping and velocity.y >= 0:
					is_jumping = false
				velocity = move_and_slide(velocity,Vector2.UP)
				velocity.x = lerp(velocity.x,0,0.2)
				if is_invulnerable:
					$Area2D/CollisionShape2D.disabled = true
				if Input.is_action_just_pressed("ui_use"):
					$ToggleArea/CollisionShape2D.disabled = false
					yield(get_tree().create_timer(0.5), "timeout")
					$ToggleArea/CollisionShape2D.disabled = true
		if !can_fly and !is_dashing and !is_gliding and !airborne_mode and !is_thrust_attacking:
			if underwater:
				velocity.y += GRAVITY / 2
			else:
				velocity.y += GRAVITY
		if airborne_mode:
			velocity.y = 0
		if !can_double_jump and is_on_floor():
			can_double_jump = true

	if is_healing:
		$Sprite.play("Healing")
	if is_frozen:
		$Sprite.play("Frozen")
	$FreezeMask.visible = true if is_frozen else false
#	if glider_equipped and !is_gliding:
#		$GliderWings.visible = true
#	if !glider_equipped or is_gliding:
#		$GliderWings.visible = false
#	if is_gliding:
#		$Sprite.play("Glide")
#		$GliderWings.visible = false

	if cam_shake:
		$Camera2D.set_offset(Vector2( \
			rand_range(-1, 1) * 8.0, \
			rand_range(-1, 1) * 10.0 \
		))
	if is_shopping:
		is_invulnerable = true
	else:
		is_invulnerable = false
	$AtkBuffParticle.visible = true if buffed_from_attack_crystals else false
	$WeakenParticles.visible = true if !$WeakenedTimer.is_stopped() else false
	charge_meter()
	
	$Sprite.visible = true if Global.current_character == "Player" else false
	if Global.current_character != "Player":
		mana_absorption_counter = mana_absorption_counter_max
		restore_mana_for_all_parties = 2
		


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


func set_basic_attack_power(amount : float, duration : float):
	# DONT ASK THIS IS SO COMPLICATED ON GODDDD
		buffed_from_attack_crystals = true
		number_of_basic_atk_buffs += 1
		prev_basic_attack_power.insert((number_of_basic_atk_buffs - 1), basic_attack_buff) 
		print(prev_basic_attack_power)
		basic_attack_buff = prev_basic_attack_power[number_of_basic_atk_buffs - 1] + amount
		print("Buffed: " + str(basic_attack_buff))
		yield(get_tree().create_timer(duration), "timeout")
		basic_attack_buff = prev_basic_attack_power[number_of_basic_atk_buffs - 1]
		print("DeBuffed: " + str(prev_basic_attack_power[number_of_basic_atk_buffs - 1]))
		number_of_basic_atk_buffs -= 1
		prev_basic_attack_power.remove(number_of_basic_atk_buffs)
		buffed_from_attack_crystals = false


		
func set_charged_attack_power(amount : float, duration : float):
		buffed_from_attack_crystals = true
		number_of_charged_atk_buffs += 1
		
		var other_groups : Array
		prev_charged_attack_power.insert((number_of_charged_atk_buffs - 1), charged_attack_buff) 
		print(prev_charged_attack_power)
		charged_attack_buff = prev_charged_attack_power[number_of_charged_atk_buffs - 1] + amount
		
		print("Buffed: " + str(charged_attack_buff))
		yield(get_tree().create_timer(duration), "timeout")
		charged_attack_buff = prev_charged_attack_power[number_of_charged_atk_buffs - 1]
		print("DeBuffed: " + str(prev_charged_attack_power[number_of_charged_atk_buffs - 1]))
		number_of_charged_atk_buffs -= 1
		prev_charged_attack_power.remove(number_of_charged_atk_buffs)
		buffed_from_attack_crystals = false
func use_skill():
	if Global.current_character == "Player":
		var player_array_index : int = Global.equipped_characters.find("Player")
		if pskill_ui.value >= pskill_ui.max_value and Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill") and !is_frozen and !is_using_primary_skill:
			use_primary_skill()
		if sskill_ui.value >= sskill_ui.max_value and Input.is_action_just_pressed("secondary_skill") and !Input.is_action_just_pressed("primary_skill") and !is_frozen and !is_using_secondary_skill:
			use_secondary_skill()
		if Input.is_action_just_pressed("tertiary_skill") and !is_frozen:
			use_tertiary_skill()
		if perkskill_ui.value >= perkskill_ui.max_value and Input.is_action_just_pressed("talent_skill") and !is_frozen:
			use_perk_skill()

func use_primary_skill():
	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
		emit_signal("skill_used", "FireSaw", attack_buff)
		emit_signal("skill_ui_update", "FireSaw")
		emit_signal("mana_changed", Global.mana, "Player")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.player_skill_multipliers["FireSawCost"]:
		emit_signal("skill_used", "FireSaw", attack_buff)
		emit_signal("skill_ui_update", "FireSaw")
		emit_signal("mana_changed", Global.character2_mana, "Player")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.player_skill_multipliers["FireSawCost"]:
		emit_signal("skill_used", "FireSaw", attack_buff)
		emit_signal("skill_ui_update", "FireSaw")
		emit_signal("mana_changed", Global.character3_mana, "Player")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()
	
func use_secondary_skill():
	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
		emit_signal("skill_used", "FireFairy", attack_buff)
		emit_signal("skill_ui_update", "FireFairy")
		emit_signal("mana_changed", Global.mana, "Player")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.player_skill_multipliers["FireFairyCost"]:
		emit_signal("skill_used", "FireFairy", attack_buff)
		emit_signal("skill_ui_update", "FireFairy")
		emit_signal("mana_changed", Global.character2_mana, "Player")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.player_skill_multipliers["FireFairyCost"]:
		emit_signal("skill_used", "FireFairy", attack_buff)
		emit_signal("skill_ui_update", "FireFairy")
		emit_signal("mana_changed", Global.character3_mana, "Player")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()

func use_tertiary_skill():
	# FIREBALL (8d6 fire damage op pls nerf)
	if Global.player_skill_multipliers["FireballCharges"] > 0:
		Global.player_skill_multipliers["FireballCharges"] -= 1
		emit_signal("update_fireball_charges_ui", Global.player_skill_multipliers["FireballCharges"])
		if !$Sprite.flip_h:
			emit_signal("skill_used", "Fireball", attack_buff, 1)
		else:
			emit_signal("skill_used", "Fireball", attack_buff, -1)
		emit_signal("skill_ui_update", "Fireball")
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaos_magic_surge()
#	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.player_skill_multipliers["FireballCost"]:
#		emit_signal("mana_changed", Global.mana, "Player")
#	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.player_skill_multipliers["FireballCost"]:
#		emit_signal("mana_changed", Global.character2_mana, "Player")
#	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.player_skill_multipliers["FireballCost"]:
#		emit_signal("mana_changed", Global.character3_mana, "Player")


func use_perk_skill():
	if Global.player_perks["CreateSugarRoll"]["unlocked"] and Global.player_perks["CreateSugarRoll"]["enabled"]:
		emit_signal("skill_used", "CreateSugarRoll")
		emit_signal("skill_ui_update", "CreateSugarRoll")
	elif Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
		
		emit_signal("skill_used", "ChaosMagic")
		emit_signal("skill_ui_update", "ChaosMagic")

func chaos_magic_surge():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, 100)
	if num <= Global.player_perks["ChaosMagic"]["triggerchance"]:
		if perkskill_ui.value >= perkskill_ui.max_value and !is_frozen:
			use_perk_skill()
#	chaos_magic(num)   


func dash_counter_attack():
	if Global.current_character == "Player" and !is_attacking and get_closest_enemy() != null:
#		is_dash_counter_attacking = true
#		$DashCounterAttackDelayTimer.start()
		if !is_on_floor() and !$HeightRaycast2D.is_colliding():
			airborne_mode = true
			$AirborneTimer.stop()
			$AirborneTimer.start()
		
		$DashCounterAttackTimer.stop()
		var counterflurryeffect = SWORD_SLASH_EFFECT.instance()
		var counterflurryarea = SLASH_FLURRY_AREA.instance()
		counterflurryarea.add_to_group("Sword")
		counterflurryarea.add_to_group(str(ATTACK * (Global.player_skill_multipliers["CounterAttack"] / 100)))
		get_parent().add_child(counterflurryarea)
		get_parent().add_child(counterflurryeffect)
		counterflurryeffect.position = get_closest_enemy().global_position
		counterflurryeffect.scale.x = 0.8
		counterflurryeffect.scale.y = 0.8
		counterflurryarea.position = get_closest_enemy().global_position
		counterflurryarea.get_node("AnimationPlayer").play("PlayerCounterAttack")
		counterflurryeffect.player_counter_attack_animation()
		yield(get_tree().create_timer(0.1), "timeout")
		update_energy_meter(10)
		change_mana_value(0.2)
		yield(get_tree().create_timer(0.1), "timeout")
		update_energy_meter(10)
		change_mana_value(0.2)
		yield(get_tree().create_timer(0.1), "timeout")
		update_energy_meter(10)
		change_mana_value(0.25)
#		yield(get_tree().create_timer(0.4), "timeout")
#		is_dash_counter_attacking = false
func attack():
	if Global.current_character == "Player" and !is_attacking and !is_gliding and !is_frozen and $MeleeTimer.is_stopped():
		$Sprite.play("Attack")
		$SwordSprite.visible = true
		if $Sprite.flip_h:
			play_attack_animation("Left")
		else:
			play_attack_animation("Right")
		is_attacking = true
		$AttackCollision/CollisionShape2D.disabled = false
		$MeleeTimer.start()
		$AttackTimer.start()

func piercing_projectile_attack(direction : int):
	var p = PIERCING_PROJECTILE.instance()
	get_parent().add_child(p)
	if direction == 1:
		p.position.x = global_position.x + 32
		p.direction = 1
	elif direction == -1:
		p.position.x = global_position.x - 32
		p.direction = -1
	p.position.y = global_position.y 
	
	
func stab_attack():
	if Global.current_character == "Player" and !is_attacking and !is_gliding and !is_frozen and $MeleeTimer.is_stopped():
		var crit_dmg : float = 1.0
		$Sprite.play("Attack")
		$SwordSprite.visible = true
		for groups in $StabAttackCollision.get_groups():
			if float(groups) != 0:
				$StabAttackCollision.remove_from_group(groups)
				break
		if is_a_critical_hit():
			crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
			$StabAttackCollision.add_to_group("IsCritHit")
		else:
			$StabAttackCollision.remove_from_group("IsCritHit")

		$StabAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["EntryAttack"] / 100) * crit_dmg))
			
		if !$Sprite.flip_h:
			$AnimationPlayer.play("SwordStabRight")
		else:
			$AnimationPlayer.play("SwordStabLeft")
		is_attacking = true
		is_switch_in_attacking = true
		$StabAttackCollision/CollisionShape2D.disabled = false

func switch_in_attack():
	if Global.current_character == "Player" and !is_attacking and !is_gliding and !is_frozen and $MeleeTimer.is_stopped():
		var crit_dmg : float = 1.0
		$Sprite.play("Attack")
		$SwordSprite.visible = true
		for groups in $SwitchAttackCollision.get_groups():
			if float(groups) != 0:
				print("its high noon")
				$SwitchAttackCollision.remove_from_group(groups)
				break
		if is_a_critical_hit():
			crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
			$SwitchAttackCollision.add_to_group("IsCritHit")
		else:
			$SwitchAttackCollision.remove_from_group("IsCritHit")

		$SwitchAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["EntryAttack"] / 100) * crit_dmg))
			
		if !$Sprite.flip_h:
			$AnimationPlayer.play("SwitchAttackRight")
		else:
			
			pass
		is_attacking = true
		is_switch_in_attacking = true
		$SwitchAttackCollision/CollisionShape2D.disabled = false
		# 0.7 is the duration of the animation


func switch_in_attack_completed():

	is_attacking = false
	is_switch_in_attacking = false


func _input(event):
	if Global.current_character == "Player":
		if event.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped() and !is_quickswap_attacking:
			if $DashCounterAttackTimer.is_stopped():
#				if has_node("FireSaw"):
#					if !$Sprite.flip_h:
#						piercing_projectile_attack(1)
#					else:
#						piercing_projectile_attack(-1)
				attack()

			else:
				# Initiates counterattack.
				if !is_dash_counter_attacking and $DashCounterAttackDelayTimer.is_stopped():
					is_invulnerable = true
					thrust_attack(true)
			$InputPressTimer.start()
		if event.is_action_pressed("ui_dash") and !mobility_lock and $DashInputPressTimer.is_stopped() and !is_quickswap_attacking:
			if get_parent().has_node("FireCharm") and weakref(get_parent().get_node("FireCharm")).get_ref() != null:
				teleport_to_firecharm()
			else:
				dash()
			$DashInputPressTimer.start()
		if event.is_action_pressed("ui_down") and airborne_mode:
			airborne_mode = false
		if event.is_action_pressed("heal"):
			if Global.healthpot_amount > 0:
				heal("Player", 5)

func charged_dash():
	$DashInputPressTimer.stop()
	if $FireCharmTimer.is_stopped():
		var fc = preload("res://scenes/skills/FireCharm.tscn").instance()
		get_parent().add_child(fc)
		fc.position = global_position
		if $Sprite.flip_h:
			fc.x_direction *= -1
		$FireCharmTimer.start()


func teleport_to_firecharm():
	var teleport_destination : Vector2 = get_parent().get_node("FireCharm").global_position
	var tp_particle = TELEPORTING_PARTICLE.instance()
	var tp_particle2 = TELEPORTING_PARTICLE.instance()
	get_parent().add_child(tp_particle)
	tp_particle.position = global_position
	tp_particle.emitting = true
	tp_particle.one_shot = true
	position.x = teleport_destination.x
	position.y = teleport_destination.y 
	get_parent().add_child(tp_particle2)
	tp_particle2.position = get_parent().get_node("FireCharm").global_position
	tp_particle2.emitting = true
	tp_particle2.one_shot = true
	get_parent().get_node("FireCharm").call_deferred('free')

	
	
func charged_attack(type : String = "Ground"):
	$InputPressTimer.stop()
	$ChargingParticle.visible = true
	is_doing_charged_attack = true
	if !$Sprite.flip_h:
		$AnimationPlayer.play("ChargedAttackRight")
	else:
		$AnimationPlayer.play("ChargedAttackLeft")
	yield(get_tree().create_timer(0.35), "timeout")
	


	
	print("normal charged attack")
	Input.action_release("ui_attack")
	# the standard charged attack.
	if type == "Ground" and !is_flurry_attacking and $EnergyMeter.value <= Global.player_skill_multipliers["SlashFlurryEnergyCost"]:
		$ChargingParticle.visible = false
		var ss_projectile = SUPER_SLASH_PROJECTILE.instance()
		ss_projectile.position = $Position2D.global_position
		get_parent().add_child(ss_projectile)
		$ChargedAttackCollision.add_to_group("SulphuricSigilTrigger")
		
		if $Sprite.flip_h:
			ss_projectile.flip_projectile(-1)
		for n in $ChargedAttackCollision.get_groups():
			if float(n) != 0:
				$ChargedAttackCollision.remove_from_group(n)
				var crit_dmg = 1.0
				if is_a_critical_hit():
					crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
					$ChargedAttackCollision.add_to_group("IsCritHit")
					$ChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["ChargedAttack"] / 100) * crit_dmg))
				else:
					$ChargedAttackCollision.remove_from_group("IsCritHit")
					$ChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["ChargedAttack"] / 100) * crit_dmg))
				emit_signal("reduce_endurance", 50)
		$ChargedAttackCollision/CollisionShape2D.disabled = false
		var hitparticle = SWORD_HIT_PARTICLE.instance()
		hitparticle.emitting = true
		get_parent().add_child(hitparticle)
		hitparticle.position = $Position2D.global_position
		#emit_signal("change_elegance"), "ChargedAttackLight")
		sheathe_katana()
		yield(get_tree().create_timer(0.15),"timeout")
		$ChargedAttackCollision.remove_from_group("SulphuricSigilTrigger")
		
	# the judgement cut-like attack
	elif type == "Circular":
		$ChargingParticle.visible = false
		var slash_effect = SWORD_SLASH_EFFECT.instance()
		var flurry = SLASH_FLURRY_AREA.instance()
		flurry.add_to_group("Sword")
		flurry.add_to_group("SulphuricSigilTrigger")
		var crit_dmg = 1.0
		
		if is_a_critical_hit():
			crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
			flurry.add_to_group(str(ATTACK * (Global.player_skill_multipliers["CircularFlurryAttack"] / 100) * crit_dmg))
			flurry.add_to_group("IsCritHit")
		else:
			flurry.add_to_group(str(ATTACK * (Global.player_skill_multipliers["CircularFlurryAttack"] / 100) * crit_dmg))
			flurry.remove_from_group("IsCritHit")
		flurry.get_node("AnimationPlayer").play("CircularFlurryAttack")
		slash_effect.get_node("SlashEffectPlayer").play("CircularFlurry")
		get_parent().get_parent().add_child(flurry)
		get_parent().get_parent().add_child(slash_effect)
		if weakref(get_closest_enemy()).get_ref() != null and $SlashFlurryDetector.overlaps_body(get_closest_enemy()):
			flurry.position = get_closest_enemy().global_position
			slash_effect.position = get_closest_enemy().global_position
		else:
			if !$Sprite.flip_h:
				velocity.x = 0
				velocity.x = -25000
				flurry.position.x = global_position.x + 150
				flurry.position.y = global_position.y
				slash_effect.position.x = global_position.x + 150
				slash_effect.position.y = global_position.y
			else:
				velocity.x = 0
				velocity.x = 25000
				flurry.position.x = global_position.x - 150
				flurry.position.y = global_position.y
				slash_effect.position.x = global_position.x - 150
				slash_effect.position.y = global_position.y
		cam_shake = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)
		velocity = dashdirection.normalized() * -850
			
	# a flurry of deadly slashes and consumes all Energy.
	elif type == "Special" and $SlashFlurryCD.is_stopped():
		$ChargingParticle.visible = false
		is_flurry_attacking = true
		velocity.y = 0
	
		var flurry = SLASH_FLURRY_AREA.instance()
		flurry.add_to_group("Sword")
		flurry.add_to_group("SulphuricSigilTrigger")
		flurry.get_node("FinalSlashArea").add_to_group("Sword")
		var crit_dmg = 1.0
		
		
		if is_a_critical_hit():
			crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
			flurry.get_node("FinalSlashArea").add_to_group(str(ATTACK * (Global.player_skill_multipliers["SpecialChargedAttackFinalStrike"] / 100) * crit_dmg))
			flurry.get_node("FinalSlashArea").add_to_group("IsCritHit")
		else:
			flurry.get_node("FinalSlashArea").add_to_group(str(ATTACK * (Global.player_skill_multipliers["SpecialChargedAttackFinalStrike"] / 100) * crit_dmg))
			flurry.get_node("FinalSlashArea").remove_from_group("IsCritHit")
		get_parent().get_parent().add_child(flurry)
		flurry.get_node("AnimationPlayer").play("FlurryAttack")
		if weakref(get_closest_enemy()).get_ref() != null and $SlashFlurryDetector.overlaps_body(get_closest_enemy()):
			flurry.position = get_closest_enemy().global_position
			
		else:
			if !$Sprite.flip_h:
				velocity.x = 0
				velocity.x = -25000
				flurry.position.x = global_position.x + 150
				flurry.position.y = global_position.y
			
			else:
				velocity.x = 0
				velocity.x = 25000
				flurry.position.x = global_position.x - 150
				flurry.position.y = global_position.y
			
		cam_shake = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)
		velocity = dashdirection.normalized() * -250
		
		var num_of_slashes : int = 1
		while num_of_slashes < 6:
			var slashparticle = SWORD_SLASH_EFFECT.instance()
			var crit_dmg_2 = 1.0
			if is_a_critical_hit():
				crit_dmg_2 = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
				flurry.add_to_group(str(ATTACK * (Global.player_skill_multipliers["SpecialChargedAttack"] / 100) * crit_dmg_2))
				flurry.add_to_group("IsCritHit")
			else:
				flurry.add_to_group(str(ATTACK * (Global.player_skill_multipliers["SpecialChargedAttack"] / 100) * crit_dmg_2))
				flurry.remove_from_group("IsCritHit")
			get_parent().add_child(slashparticle)
			slashparticle.position = flurry.global_position
			yield(get_tree().create_timer(0.075), "timeout")
			slashparticle.flurry_slash_animation(num_of_slashes)
			num_of_slashes += 1
		
		#emit_signal("change_elegance"), "ChargedAttackLight")
		change_mana_value(0.25)
		yield(get_tree().create_timer(0.1), "timeout")
		#emit_signal("change_elegance"), "ChargedAttackLight")
		change_mana_value(0.25)
		yield(get_tree().create_timer(0.1), "timeout")
		#emit_signal("change_elegance"), "ChargedAttackLight")
		change_mana_value(0.3)
		yield(get_tree().create_timer(0.1), "timeout")
		#emit_signal("change_elegance"), "ChargedAttackLight")
		change_mana_value(0.3)
		yield(get_tree().create_timer(0.1), "timeout")
		change_mana_value(0.5)
		#emit_signal("change_elegance"), "ChargedAttackHeavy")
		emit_signal("reduce_skill_cd", "Player", "PrimariesOnly", 4)
		emit_signal("reduce_skill_cd", "Player", "SecondariesOnly", 2)
		
		# burningbreathtalent
	
		$SlashFlurryCD.start()
		cam_shake = false
		
		is_flurry_attacking = false
		if !is_flurry_attacking:
			energy_full = false
			update_energy_meter(10)
		sheathe_katana()
	elif "SpecialAerial":
		pass
	cam_shake = true
	yield(get_tree().create_timer(0.25), "timeout")
	cam_shake = false
	var dash_particle = DASH_PARTICLE.instance()
	get_parent().add_child(dash_particle)
	dash_particle.position = $Position2D.global_position
	dash_particle.emitting = true
	dash_particle.one_shot = true
	yield(get_tree().create_timer(0.1), "timeout")
	$ChargedAttackCollision/CollisionShape2D.disabled = true
	is_doing_charged_attack = false
	attack_string_count = 4
	is_charging = false
	Input.action_release("ui_attack")

func charge_meter():
	if Global.current_character == "Player":
		if Input.is_action_just_released("ui_attack"):
			$InputPressTimer.stop()
			print("cancel atk input")
		$ChargingParticle.visible = true if is_charging else false
		if !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
			if Input.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped():
				$InputPressTimer.start()
				
#			elif Input.is_action_just_pressed("ui_attack") and $ChargeBar.value == $ChargeBar.max_value and Global.mana < 2:
#				$ChargeBar.visible = false
#				$ChargeBar.value = $ChargeBar.min_value
#				is_charging = false
#			if Input.is_action_just_pressed("jump") and Global.mana >= 1 and glider_equipped and is_on_floor() and !is_attacking and !is_frozen and !underwater:
#				if !Global.godmode:
#					Global.mana -= 1
#					emit_signal("mana_changed", Global.mana, "Player")
#				attack_string_count = 4
#				mana_absorption_counter = mana_absorption_counter_max
#				Input.action_release("charge")
#				is_charging = false
#				$ChargeBar.visible = false
#				$ChargeBar.value = $ChargeBar.min_value
#				velocity.y = JUMP_POWER * 1.5
#				$Sprite.play("Idle")
#				is_attacking = false
		if Input.is_action_pressed("ui_up") and !airborne_mode:
			if Input.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped() and !is_doing_charged_attack:
				$InputPressTimer.start()
				

func upwards_charged_attack():
	if target and target != null and weakref(target).get_ref() != null and !target.is_in_group("Projectile"): 
		if target.get_node("Area2D").overlaps_area($ChargedAttackDetector) and !target.get_node("Area2D").is_in_group("IsAirborne"):
			knock_airborne(target.get_node("Area2D"))

	$ChargingParticle.visible = true
	resist_interruption = true
	attack_string_count = 4
	for n in $UpwardsChargedAttackCollision.get_groups():
		if float(n) != 0:
			
			$UpwardsChargedAttackCollision.remove_from_group(n)
			var crit_dmg = 1.0
			if is_a_critical_hit():
				crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
				$UpwardsChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["UpwardsChargedAttack"] / 100) * crit_dmg))
				$UpwardsChargedAttackCollision.add_to_group("IsCritHit")
			else:
				$UpwardsChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["UpwardsChargedAttack"] / 100) * crit_dmg))
				$UpwardsChargedAttackCollision.remove_from_group("IsCritHit")
	$UpwardsChargedAttackCollision/CollisionShape2D.disabled = false	
	resist_interruption = true
	is_charging = false
#			airborne_mode = false
	is_doing_charged_attack = true
	cam_shake = true
	velocity.y = 0
	velocity.y = -1065
	var sjp = STRONG_JUMP_PARTICLE.instance()
	get_parent().add_child(sjp)
	sjp.position = $ParticlePosition.global_position
	sjp.emitting = true
	if !$Sprite.flip_h:
		$AnimationPlayer.play("KnockUpChargedAttackRight")
		yield(get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("KnockUpChargedAttackRight")
	else:
		$AnimationPlayer.play("KnockUpChargedAttackLeft")
		yield(get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("KnockUpChargedAttackLeft")
	
	is_doing_charged_attack = false
	Input.action_release("ui_attack")

	$UpwardsChargedAttackCollision/CollisionShape2D.disabled = true
	cam_shake = false
	#emit_signal("change_elegance"), "ChargedAttackLight")
	
	yield(get_tree().create_timer(0.25), "timeout")
	resist_interruption = false
	$ChargingParticle.visible = false
	
func downwards_charged_attack():
	airborne_mode = false
	resist_interruption = true
	attack_string_count = 4
	$ChargingParticle.visible = true
	for n in $DownwardsChargedAttackCollision.get_groups():
		if float(n) != 0:
			$DownwardsChargedAttackCollision.remove_from_group(n)
			var crit_dmg = 1.0
			if is_a_critical_hit():
				crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
				$DownwardsChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["DownwardsChargedAttack"] * 2 / 100) * crit_dmg))
				$DownwardsChargedAttackCollision.add_to_group("IsCritHit")
			else:
				$DownwardsChargedAttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["DownwardsChargedAttack"] * 2/ 100) * crit_dmg))
				$DownwardsChargedAttackCollision.remove_from_group("IsCritHit")
	$DownwardsChargedAttackCollision/CollisionShape2D.disabled = false
	resist_interruption = true
	is_charging = false
#			airborne_mode = false
	is_doing_charged_attack = true
	cam_shake = true
	velocity.y = 0
	velocity.y = 500
	var sjp = STRONG_JUMP_PARTICLE.instance()
	get_parent().add_child(sjp)
	sjp.position = $ParticlePosition.global_position
	sjp.emitting = true
	if !$Sprite.flip_h:
		$AnimationPlayer.play("KnockDownChargedAttackRight")
		yield(get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("KnockDownChargedAttackRight")
	else:
		$AnimationPlayer.play("KnockDownChargedAttackLeft")
		yield(get_tree().create_timer(0.2), "timeout")
		$AnimationPlayer.play("KnockDownChargedAttackLeft")
	$ChargingParticle.visible = false
	is_doing_charged_attack = false
	Input.action_release("ui_attack")

	$DownwardsChargedAttackCollision/CollisionShape2D.disabled = true
	cam_shake = false
	#emit_signal("change_elegance"), "ChargedAttackLight")
	yield(get_tree().create_timer(0.25), "timeout")
	resist_interruption = false
	


func sheathe_katana():
	yield(get_tree().create_timer(2), "timeout")
	if weakref(get_closest_enemy()).get_ref() != null and global_position.distance_to(get_closest_enemy().global_position) > 100 or get_closest_enemy() == null:
		if Global.current_character == "Player" and !is_attacking and !is_sheathing and $KatanaSheatheWindowTimer.is_stopped():
			is_sheathing = true
#			if !$Sprite.flip_h:
#				$KatanaSheathPlayer.play("RightDefaultSheath")
#			else:
#				$KatanaSheathPlayer.play("LeftDefaultSheath")
#
			
			print("SHEATHING")
			$KatanaSheatheWindowTimer.start()

func calculate_damage(slash_animation : String , slash_direction_animation : String, attack_string : String, airborne_attack_string : String, hit_id : String = ""):
	$ResetAttackStringTimer.stop()
	$AnimationPlayer.play(slash_animation)

	attack_string_count -= 1
#	$SlashEffectPlayer.play(slash_direction_animation)
	
	for groups in $AttackCollision.get_groups():
		if float(groups) != 0:
			$AttackCollision.remove_from_group(groups)
			$AttackCollision.add_to_group(hit_id)
			var crit_dmg : float = 1.0
			if is_a_critical_hit():
				crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
				$AttackCollision.add_to_group("IsCritHit")
			else:
				$AttackCollision.remove_from_group("IsCritHit")
			if !airborne_mode:
				$AttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers[attack_string] / 100) * crit_dmg))
				
			else:
				$AttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers[airborne_attack_string] / 100) * crit_dmg))
			break
	
	sheathe_katana()
	$ResetAttackStringTimer.start()

func play_attack_animation(direction : String):
	if direction == "Right":
		match attack_string_count:
			4:
				
				calculate_damage("SwordSwingRight", "RightSlash", "BasicAttack", "AirborneBasicAttack", "PlayerBasicAttackOne")
			3:
				calculate_damage("SwordSwingRight2", "RightSlash", "BasicAttack2", "AirborneBasicAttack2", "PlayerBasicAttackTwo")
			2:
				calculate_damage("SwordSwingRight3", "RightSlash", "BasicAttack3", "AirborneBasicAttack3", "PlayerBasicAttackThree")
			1:
				
				attack_string_count -= 1
				
#				$SlashEffectPlayer.play("RightSlash")
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group("PlayerBasicAttackFour")
						var crit_dmg : float = 1.0
						if Input.is_action_pressed("ui_down"):
							stab_attack()
						else:
							
							$AnimationPlayer.play("SwordSwingRight4")
			
							
						$AttackCollision.remove_from_group("Airborne")
						if is_a_critical_hit():
							crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
							$AttackCollision.add_to_group("IsCritHit")
						else:
							$AttackCollision.remove_from_group("IsCritHit")
						if !airborne_mode:
							$AttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["BasicAttack4"] / 100) * crit_dmg))
						else:
							$AttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["AirborneBasicAttack4"] / 100 * crit_dmg)))
						break

				sheathe_katana()
				yield(get_tree().create_timer($MeleeTimer.wait_time), "timeout")
				$AttackCollision.remove_from_group("Airborne")
				attack_string_count = 4
				mana_absorption_counter = mana_absorption_counter_max
	elif direction == "Left":
		match attack_string_count:
			4:
				calculate_damage("SwordSwingLeft", "LeftSlash", "BasicAttack", "AirborneBasicAttack", "PlayerBasicAttackOne")
			3:
				calculate_damage("SwordSwingLeft2", "LeftSlash", "BasicAttack2", "AirborneBasicAttack2", "PlayerBasicAttackTwo")
			2:
				calculate_damage("SwordSwingLeft3", "LeftSlash", "BasicAttack3", "AirborneBasicAttack3", "PlayerBasicAttackThree")
			1:
				$AnimationPlayer.play("SwordSwingLeft4")
				attack_string_count -= 1
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						$AttackCollision.add_to_group("PlayerBasicAttackFour")
						var crit_dmg : float = 1.0
						if Input.is_action_pressed("ui_down"):
							stab_attack()
						else:
							$AnimationPlayer.play("SwordSwingLeft4")
						$AttackCollision.remove_from_group("Airborne")
						if is_a_critical_hit():
							crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
							$AttackCollision.add_to_group("IsCritHit")
						else:
							$AttackCollision.remove_from_group("IsCritHit")
						if !airborne_mode:
							$AttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["BasicAttack4"] / 100) * crit_dmg))
							print("a")
						else:
							$AttackCollision.add_to_group(str(ATTACK * (Global.player_skill_multipliers["AirborneBasicAttack4"] / 100 * crit_dmg)))
							print("b")
						break
				sheathe_katana()
				yield(get_tree().create_timer($MeleeTimer.wait_time), "timeout")
				attack_string_count = 4
				mana_absorption_counter = mana_absorption_counter_max
# Damage and interaction
func _on_Area2D_area_entered(area : Area2D):
	
	if Global.current_character == "Player":
		if area.is_in_group("HealthPot"):
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		if area.is_in_group("LootBag"):
			
			on_loot_bag_obtained(
				area.get_parent().opals_amount, 
				area.get_parent().drops_table["common_dust"],
				area.get_parent().drops_table["goblin_scales"],
				area.get_parent().drops_table["bat_wings"],
				area.get_parent().drops_table["sweet_herbs"]
			)
		if area.is_in_group("ImmortalityField"):
			is_in_immortality_field = true
		if area.is_in_group("HealthPack") and area.is_in_group("Active"):
			# The 999 value is not relevant since health packs heal to maximum amount
			heal("Player", 999, true)
		if area.is_in_group("LifeWine"):
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		if area.is_in_group("AddMana"):
			change_mana_value(area.get_parent().mana_granted)

		if area.is_in_group("Heal"):
			heal("Player", area.add_health / 100 * Global.character_health_data["Player"])
		if !Global.godmode:
			if inv_timer.is_stopped() and !is_invulnerable and !is_dashing and !is_thrust_attacking:
				if area.is_in_group("Enemy") and area.is_in_group("Hostile") or area.is_in_group("Projectile"):
					print("HURT")
					var enemy_elemental_type : String = area.get_parent().elemental_type
					var enemy_atk_value : float = area.get_parent().atk_value
						
					match enemy_elemental_type:
						"Physical":
							take_damage(enemy_atk_value * (1 - phys_res))
						"Fire":
							take_damage(enemy_atk_value - (1 - fire_res))
					is_gliding = false
					Input.action_release("ui_attack")
					after_damaged()
					if !area.is_in_group("LightEnemy") or !resist_interruption:
						knockback()
					$CampfireTimer.stop()
			
					 
#				if area.is_in_group("Enemy2"):
#					take_damage(2)
#					add_hurt_particles(1)
#					is_gliding = false
#					Input.action_release("charge")
#					afterDamaged()
#					knockback()
#					$CampfireTimer.stop()
			if area.is_in_group("Spike"):
				Global.hearts -= 0.5
				Input.action_release("charge")
				after_damaged()
				$CampfireTimer.stop()
#		if area.is_in_group("SlowingPoison"):
#			slow_player(2.0)
		if area.is_in_group("Transporter"):
			emit_signal("level_changed")
		if area.is_in_group("Water"):
			$OxygenBar.visible = true
			var water_jump_particle = WATER_JUMP_PARTICLE.instance()
			water_jump_particle.emitting = true
			get_parent().add_child(water_jump_particle)
			water_jump_particle.position = $ParticlePosition.global_position
			$OxygenTimer.start()
			underwater = true
			velocity.y = 0
			print("is underwater")
		if area.is_in_group("BasicAttackBuff"):
			basicatkbuffmulti = area.amount
			basicatkbuffdur = area.duration
			set_basic_attack_power(float(basicatkbuffmulti), float(basicatkbuffdur))
		if area.is_in_group("AttackBuff"):
			atkbuffmulti = area.amount
			atkbuffdur = area.duration
			set_attack_power(area.type, float(atkbuffmulti), float(atkbuffdur))
		if area.is_in_group("Weaken") and $WeakenedTimer.is_stopped():
			atkbuffmulti = area.amount
			atkbuffdur = area.duration
			set_attack_power(area.type, float(atkbuffmulti), float(atkbuffdur), false)
			$WeakenedTimer.wait_time = area.duration
			$WeakenedTimer.start()
		
func take_damage(damage : float):
	var def = Global.character_defense_data["Player"] / 100
	if Global.current_character == "Player" and !is_invulnerable:
		if $TalentsNode2D/BurningBreathCDTimer.is_stopped() and Global.player_talents["BurningBreath"]["unlocked"] and Global.player_talents["BurningBreath"]["enabled"]:
			var burningbreath = BURNING_BREATH_TALENT.instance()
			if !$Sprite.flip_h:
				burningbreath.direction = 1
			else:
				burningbreath.direction = -1
			get_parent().add_child(burningbreath)
			burningbreath.position = global_position
			burningbreath.get_node("FireBurstParticle").emitting = true
			$TalentsNode2D/BurningBreathCDTimer.start()
#			print("HELLISH REBUKE")
		
		if Global.equipped_characters[0] == "Player":
			if shield_hp > 0:
				shield_hp = clamp(shield_hp - damage, 0, 999)
				$Shield/ShieldHPBar.value = shield_hp
			else:
				Global.hearts -= damage * (1 - def)
				add_hurt_particles(damage * (1 - def))
				emit_signal("life_changed", Global.hearts, "Player")
		elif Global.equipped_characters[1] == "Player":
			if shield_hp > 0:
				shield_hp = clamp(shield_hp - damage, 0, 999)
				$Shield/ShieldHPBar.value = shield_hp
			else:
				Global.character2_hearts -= damage * (1 - def) 
				add_hurt_particles(damage * (1 - def))
				#emit_signal("change_elegance"), "Hit")
				emit_signal("life_changed", Global.character2_hearts, "Player")
		elif Global.equipped_characters[2] == "Player":
			if shield_hp > 0:
				shield_hp = clamp(shield_hp - damage, 0, 999)
				$Shield/ShieldHPBar.value = shield_hp
			else:
				Global.character3_hearts -= damage * (1 - def)
				add_hurt_particles(damage * (1 - def))
				#emit_signal("change_elegance"), "Hit")
				emit_signal("life_changed", Global.character3_hearts, "Player")
#		print(shield_hp)

func heal(character : String = "Player", heal_amount : float = 0, heal_to_max : bool = false, consumes_potion : bool = true):
	# heal amount in percentage based on max HP
	print("HEALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")
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
	

	
func _on_Area2D_area_exited(area):
	if area.is_in_group("Water"):
		
		underwater = false
		yield(get_tree().create_timer(1), "timeout")
		$OxygenTimer.stop()
		if $OxygenBar.value < 100:
			$OxygenRefillTimer.start()
		print("not underwater")
	if area.is_in_group("ImmortalityField"):
		is_in_immortality_field = false
func attack_knock():
	var KNOCK_POWER : int = 75
	velocity.x = -KNOCK_POWER if !$Sprite.flip_h else KNOCK_POWER

func after_damaged():
	inv_timer.start() 
	$HurtAnimationPlayer.play("Hurt")
	is_invulnerable = true
#	emit_signal("life_changed", Global.hearts)
	$Sprite.play("Hurt")
	if !Global.godmode:
		$KnockbackTimer.start()
		
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
	is_invulnerable = true
	$InvulnerabilityTimer.start()
	swap_to_nearby_alive_characters()
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
				heal(c, 999, true)
			counter_sec += 1
		get_parent().get_node("GameOverUI/GameOver").open_game_over_ui()

func add_death_particles():
	var deathparticle = DEATH_SMOKE_PARTICLE.instance()
	deathparticle.emitting = true
	deathparticle.position = global_position
	get_parent().add_child(deathparticle)
func swap_to_nearby_alive_characters():
	print("SWAPPPP")
	for c in Global.alive:
		if c == true:
			var pos = Global.alive.find(c) + 1
			emit_signal("force_character_swap", pos)
			break


func add_hurt_particles(damage : float):
	var hurt_particle = HURT_PARTICLE.instance()
	hurt_particle.damage = damage * 2
	get_parent().add_child(hurt_particle)
	hurt_particle.position = global_position

func add_heal_particles(heal_amount : float):
	var heal_particle = HEAL_PARTICLE.instance()
	heal_particle.heal_amount = heal_amount * 2
	get_parent().add_child(heal_particle)
	heal_particle.position = global_position
	# trigger health effect particles
	$HealingParticles.emitting = true

# Obtaining mana by attacking enemies

func is_a_critical_hit() -> bool:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var num = rng.randi_range(0 ,100)
	if num <= Global.player_skill_multipliers["CritRate"]:
		return true
	else:
		return false

func _on_AttackCollision_area_entered(area):
	if weakref(area).get_ref() != null:
		if area.is_in_group("Enemy")  and !$AttackCollision/CollisionShape2D.disabled:
			print(attack_string_count)
			if !is_on_floor() and !$HeightRaycast2D.is_colliding():
				airborne_mode = true
				$AirborneTimer.stop()
				$AirborneTimer.start()
			attack_area_overlaps_enemy = true
#			attack_knock()
#			freeze_enemy()
			if Global.current_character == "Player":
				if area.is_in_group("Enemy") and $ManaRegenDelay.is_stopped() and !is_flurry_attacking:
					var bonus_energy_gain : int = 0
					if airborne_mode:
						bonus_energy_gain = 2.5
					match attack_string_count:
						3:
							update_energy_meter(5 + bonus_energy_gain)
#							emit_signal("change_hitcount", 1)
						2:
							update_energy_meter(5 + bonus_energy_gain)
#							emit_signal("change_hitcount", 1)
#							emit_signal("change_hitcount", 1)
							yield(get_tree().create_timer(0.2), "timeout")
							update_energy_meter(5 + bonus_energy_gain)
						1:
							update_energy_meter(10 + bonus_energy_gain * 2)
#							emit_signal("change_hitcount", 1)
						0:
							update_energy_meter(15 + bonus_energy_gain * 3)
#							emit_signal("change_hitcount", 1)
#							emit_signal("reduce_skill_cd", "Player", "PrimarySkill", 1)
#							emit_signal("reduce_skill_cd", "Player", "SecondarySkill", 1)
#					#emit_signal("change_elegance"), "BasicAttack")
					change_mana_value(0.25)
					$ManaRegenDelay.start()
				if weakref(area).get_ref() != null:
					var slashparticle = SWORD_SLASH_EFFECT.instance()
					var hitparticle = SWORD_HIT_PARTICLE.instance()
					get_parent().add_child(slashparticle)
					get_parent().add_child(hitparticle)
					hitparticle.emitting = true
					hitparticle.position = area.global_position
					slashparticle.position = area.global_position
					slashparticle.regular_slash_animation()
				if mana_absorption_counter > 0:
					mana_absorption_counter -= 1
				
#				if mana_absorption_counter == 0 and $ChargeBar.value != $ChargeBar.max_value:
#					mana_absorption_counter = mana_absorption_counter_max
	
#	if weakref(area).get_ref() != null:
#		if area.is_in_group("Airborne"):
#
#			get_node("AirborneTimer").start()
#			airborne_mode = true

func _on_ChargedAttackCollision_area_entered(area):
	if weakref(area).get_ref() != null:
		if area.is_in_group("Enemy"):
			if Global.current_character == "Player" and $ManaRegenDelay.is_stopped():
				$ManaRegenDelay.start()
				print("charged attack restore mana")
				change_mana_value(0.35)
				print("mana: " + str(Global.mana))
				if !is_flurry_attacking:
					update_energy_meter(10)
				if mana_absorption_counter > 0:
					mana_absorption_counter -= 1
	
func change_mana_value(amount : float):
	if Global.current_character == Global.equipped_characters[0] and Global.mana < Global.max_mana:
		Global.mana += amount
		Global.mana = clamp(Global.mana, 0, Global.max_mana)
		emit_signal("mana_changed", Global.mana, "Player")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana < Global.character2_max_mana:
		Global.character2_mana += amount
		Global.character2_mana = clamp(Global.character2_mana, 0, Global.character2_max_mana)
		emit_signal("mana_changed", Global.character2_mana, "Player")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana < Global.character3_max_mana:
		Global.character3_mana += amount
		Global.character3_mana = clamp(Global.character3_mana, 0, Global.character3_max_mana)
		emit_signal("mana_changed", Global.character3_mana, "Player")
func freeze_enemy():
	var frozen_status = FROZEN.instance()
	var enemy = $AttackCollision.get_overlapping_areas()
	print(enemy)
	for e in enemy:
		if e.is_in_group("Enemy"):
			e.add_child(frozen_status)
	enemy.clear()


func knockback():
	if can_be_knocked and !Global.godmode and !resist_interruption and !is_invulnerable:
		is_knocked_back = true
		$KnockbackCooldownTimer.start()
		can_be_knocked = false
#		Input.action_release("left")
#		Input.action_release("right")
		Input.action_release("ui_attack")
		Input.action_release("jump")
#		if !$Sprite.flip_h:
#			velocity.x = 0
#			velocity.x = -knockback_power 
#		else:
#			velocity.x = 0
#			velocity.x = knockback_power 
#		yield(get_tree().create_timer(0.3), "timeout")
#		$KnockbackrecoveryTimer.start()
		
	dashdirection = Vector2(-1, 0) if $Sprite.flip_h else Vector2(1,0)
	Input.action_release("jump")
#	Input.action_release("left")
#	Input.action_release("right")
	Input.action_release("ui_attack")
	Input.action_release("ui_up")

func _on_LeftDetector_area_entered(area):
	if !Global.godmode and !is_thrust_attacking and !mobility_lock:
		if $KnockbackCooldownTimer.is_stopped() and !is_invulnerable and area.is_in_group("Enemy") or area.is_in_group("Enemy2") and !is_knocked_back:
			yield(get_tree().create_timer(0.1),"timeout")

			velocity.x = 0
			if !airborne_mode:
				velocity.x = knockback_power
			$KnockbackCooldownTimer.start()
func _on_RightDectector_area_entered(area):
	if !Global.godmode and !is_thrust_attacking and !mobility_lock:
		if $KnockbackCooldownTimer.is_stopped() and !is_invulnerable and area.is_in_group("Enemy") or area.is_in_group("Enemy2") and !is_knocked_back:
			yield(get_tree().create_timer(0.1),"timeout")

			velocity.x = 0
			if !airborne_mode:
				velocity.x = -knockback_power
			$KnockbackCooldownTimer.start()


func dash():
	if stamina_bar_ui.value >= DASH_STAMINA_COST and !is_frozen and !is_thrust_attacking and !$DashCooldown.is_stopped() and $DashAfterJumpingDelayTimer.is_stopped():
		if $DashUseTimer.is_stopped():
			can_dash = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)
		stamina_bar_ui.value -= DASH_STAMINA_COST
		if can_dash and $DashUseTimer.is_stopped():
			attack_string_count = 4
			mana_absorption_counter = mana_absorption_counter_max
			is_dashing = true
			var dash_particle = DASH_PARTICLE.instance()
			get_parent().add_child(dash_particle)
			if !$Sprite.flip_h:
				dash_particle.rotation_degrees = 180
			dash_particle.position = $DashParticlePosition.global_position
			dash_particle.emitting = true
			dash_particle.one_shot = true
			can_dash = false
			Input.action_release("jump")
			$DashUseTimer.start()
			if !$HeightRaycast2D.is_colliding():
				airborne_mode = true
				$AirborneMaxDuration.start()
			if !Input.is_action_pressed("ui_down"): 
				if !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
					velocity.y = 0
					$Sprite.play("BackwardsDash")
					velocity = dashdirection.normalized() * -2000
					if perfect_dash and !airborne_mode and is_on_floor():
					
						can_use_slash_flurry = true
						#emit_signal("change_elegance"), "PerfectDash")
						$DashCounterAttackTimer.start()
				else:
					velocity.y = 0
					$Sprite.play("Dash")
					velocity = dashdirection.normalized() * 2800
			
			if Input.is_action_pressed("ui_down") and !is_on_floor():
				airborne_mode = false
				velocity.y = 0
				velocity.y = 2000
			yield(get_tree().create_timer(0.25), "timeout")
			perfect_dash = false
			airborne_mode = false
			$DashCooldown.start()
			
			velocity.y += GRAVITY
			is_dashing = false

func thrust_attack(special : bool = false):
	if !is_dash_counter_attacking and $DashCounterAttackDelayTimer.is_stopped():
		is_invulnerable = true
		print("THRUSTING TTTHTHHTTH")
		is_dash_counter_attacking = true
		$DashCounterAttackDelayTimer.start()
		for n in $ThrustEffectArea.get_groups():
			if float(n) != 0:
				$ThrustEffectArea.remove_from_group(n)
				var crit_dmg = 1.0
				if is_a_critical_hit():
					crit_dmg = (Global.player_skill_multipliers["CritDamage"] / 100 + 1)
					$ThrustEffectArea.add_to_group(str(ATTACK * (Global.player_skill_multipliers["ThrustChargedAttack"] / 100) * crit_dmg))
					$ThrustEffectArea.add_to_group("IsCritHit")
				else:
					$ThrustEffectArea.add_to_group(str(ATTACK * (Global.player_skill_multipliers["ThrustChargedAttack"] / 100) * crit_dmg))
					$ThrustEffectArea.remove_from_group("IsCritHit")
				#emit_signal("change_elegance"), "ChargedAttackLight")
		$ThrustEffectArea/CollisionShape2D.add_to_group("SulphuricSigilTrigger")
		$ThrustEffectArea/CollisionShape2D.disabled = false
		
		is_thrust_attacking = true
		
		var thrustdirection : Vector2
	#	cam_shake = true
		var swordslash = SWORD_SLASH_EFFECT.instance()
		if  weakref(get_closest_enemy()).get_ref() != null:
			if get_closest_enemy().position.x < position.x:
				thrustdirection = Vector2(-1, 0)
				$Sprite.flip_h = true
			elif get_closest_enemy().position.x >= position.x:
				thrustdirection = Vector2(1, 0)
				$Sprite.flip_h = false
		else:
			if !$Sprite.flip_h:
				thrustdirection = Vector2(1,0)
			if $Sprite.flip_h:
				thrustdirection = Vector2(-1, 0)
		attack_string_count = 4
		mana_absorption_counter = mana_absorption_counter_max
		var dash_particle = DASH_PARTICLE.instance()
		get_parent().add_child(dash_particle)
		if !$Sprite.flip_h:
			dash_particle.rotation_degrees = 180
		dash_particle.position = $DashParticlePosition.global_position
		dash_particle.emitting = true
		dash_particle.one_shot = true
		get_parent().add_child(swordslash)
		swordslash.position = global_position
		swordslash.horizontal_slash_animation()
		Input.action_release("jump")
		velocity.y = 0
		change_mana_value(0.5)
		$Sprite.play("Dash")

		if special:
			is_invulnerable = true
			velocity = thrustdirection.normalized() * 3600
			yield(get_tree().create_timer(0.2), "timeout")
			$ThrustEffectArea/CollisionShape2D.disabled = true
			yield(get_tree().create_timer(0.25), "timeout")
			dash_counter_attack()
			is_thrust_attacking = false
			yield(get_tree().create_timer(0.5), "timeout")
			if !is_flurry_attacking:
				update_energy_meter(25)
		else:
			velocity = thrustdirection.normalized() * 2950
			is_thrust_attacking = false
			
			
	#		$AirborneMaxDuration.start()
			yield(get_tree().create_timer(0.1), "timeout")
			$ThrustEffectArea/CollisionShape2D.disabled = true
			yield(get_tree().create_timer(0.35), "timeout")
	#		cam_shake = false
			is_invulnerable = false
			if Global.player_talents["SwiftThrust"]["unlocked"] and Global.player_talents["SwiftThrust"]["enabled"]:
				airborne_mode = true
				yield(get_tree().create_timer(0.5), "timeout")
				airborne_mode = false
			else:
				airborne_mode = false
			if !is_flurry_attacking:
				update_energy_meter(15)
		
		sheathe_katana()
	
func knock_airborne(target):
	if target and weakref(target).get_ref() != null and !target.is_in_group("IsAirborne") and !target.get_parent().is_in_group("Armored"):
		if $KnockAirborneICD.is_stopped():
			var airborne_status := AIRBORNE_STATUS.instance()
			target.get_parent().add_child(airborne_status)
			$KnockAirborneICD.start()

#func glide():
#	# Press SPACE while in mid-air to temporarily glide
#	if Input.is_action_just_pressed("jump") and !is_on_floor():
##		if !Global.godmode:
##			$GlideTimer.start(0)
#		is_gliding = true
#		if is_on_floor() or is_on_wall() or is_on_ceiling():
##			$GlideTimer.stop()
#			is_gliding = false
#			velocity.y += GRAVITY * 3
#		if is_gliding:
#			velocity.y = 0
#			velocity.y += GRAVITY * 0.75
#		print("GLIDDINH")
#	# Stop gliding
#	if Input.is_action_just_released("jump") or is_on_floor():
#		$GlideTimer.stop()
#		is_gliding = false
##		if !airborne_mode:
#		velocity.y += GRAVITY * 3


func useItems():
	pass
#	if !is_frozen:
#		if Input.is_action_just_pressed("slot_1") and Global.hearts < Global.max_hearts and Global.healthpot_amount > 0:
#			heal_player("HealthPot")
#		# Life wines (Increase maximum health)
#		elif Input.is_action_just_pressed("slot_2") and Global.hearts < Global.max_hearts and Global.lifewine_amount > 0:
#			heal_player("LifeWine")
#		elif Input.is_action_just_pressed("slot_3") and Global.mana < Global.max_mana and Global.manapot_amount > 0: 
#			heal_player("ManaPot")



func game_over():
	get_parent().get_node("DebugMenu").get_node("Control").visible = false
	is_dead = true
	velocity = Vector2(0,0)
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	get_parent().get_node("GameOverUI/GameOver").visible = true



func on_manashrine_toggled():
	is_healing = true
	yield(get_tree().create_timer(2), "timeout")
	Global.mana += Global.max_mana - Global.mana
	emit_signal("mana_changed", Global.mana, Global.equipped_characters[0])
	emit_signal("mana_changed", Global.mana, Global.equipped_characters[1])
	emit_signal("mana_changed", Global.mana, Global.equipped_characters[2])
	is_healing = false
	
func on_loot_bag_obtained(opals : int = 0, common_dust : int = 0, goblin_scales : int = 0, bat_wings : int = 0, sweet_herbs : int = 0 ):
	get_opals(opals)
	Global.drops_inventory["common_dust"] += common_dust
	emit_signal("ingredient_obtained", "common_dust", common_dust)
	Global.drops_inventory["goblin_scales"] += goblin_scales
	emit_signal("ingredient_obtained", "goblin_scales", goblin_scales)
	Global.drops_inventory["bat_wings"] += bat_wings
	emit_signal("ingredient_obtained", "bat_wings", bat_wings)
	Global.drops_inventory["sweet_herbs"] += sweet_herbs
	emit_signal("ingredient_obtained", "sweet_herbs", sweet_herbs)
func on_Item_bought(item_name : String, item_price : int):
	Global.opals_amount -= item_price
	emit_signal("opals_obtained", Global.opals_amount)
	match item_name:
		"HealthPot":
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		"ManaPot":
			Global.manapot_amount += 1
			emit_signal("manapot_obtained", Global.manapot_amount)
		"LifeWine":
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		"ItemPouch_1":
			pass
#func on_Item_crafted(item_name : String, common_dust : int, goblin_scales : int):
#	print("signal sent")
#	Global.common_monster_dust_amount -= common_dust
#	Global.goblin_scales_amount -= goblin_scales
#	emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
#	emit_signal("goblin_scales_obtained", Global.goblin_scales_amount)
#	match item_name:
#		"HealthPot":
#			Global.healthpot_amount += 1
#			emit_signal("healthpot_obtained", Global.healthpot_amount)
#		"ManaPot":
#			Global.manapot_amount += 1
#			emit_signal("manapot_obtained", Global.manapot_amount)
#		"LifeWine":
#			Global.lifewine_amount += 1
#			emit_signal("lifewine_obtained", Global.lifewine_amount)
#		"ItemPouch_1":
#			pass


func debug_commands(cmd : String):
	match cmd:
		"opened":
			is_shopping = true
		"closed":
			is_shopping = false
		"freeze":
			is_frozen = true if !is_frozen else false
		"fillall":
			Global.healthpot_amount += Global.max_item_storage - Global.healthpot_amount
			emit_signal("healthpot_obtained", Global.healthpot_amount)
			Global.manapot_amount += Global.max_item_storage - Global.manapot_amount
			emit_signal("manapot_obtained", Global.manapot_amount)
			Global.lifewine_amount += Global.max_item_storage - Global.lifewine_amount
			emit_signal("lifewine_obtained", Global.lifewine_amount)
			Global.crystals_amount += Global.max_item_storage - Global.crystals_amount
			emit_signal("crystals_obtained", Global.crystals_amount)
		"opalall":
			Global.opals_amount += 999 - Global.opals_amount
			emit_signal("opals_obtained", Global.opals_amount)
		"healall":
			if Global.equipped_characters[0] != "":
				Global.hearts = Global.max_hearts
				emit_signal("life_changed", Global.hearts)
				Global.mana = Global.max_mana
				emit_signal("mana_changed", Global.mana, Global.equipped_characters[0])
			if Global.equipped_characters[1] != "":
				Global.character2_hearts = Global.character_2_max_hearts 
				emit_signal("life_changed", Global.character2_hearts)
				Global.character2_mana = Global.character2_max_mana
				emit_signal("mana_changed", Global.character2_mana, Global.equipped_characters[1])
			if Global.equipped_characters[2] != "":
				Global.character3_hearts = Global.character_3_max_hearts
				emit_signal("life_changed", Global.character3_hearts)
				Global.character3_mana = Global.character3_max_mana
				emit_signal("mana_changed", Global.character3_mana, Global.equipped_characters[2])
		"killall":
			for enemy in get_tree().get_nodes_in_group("Enemy"):
				enemy.queue_free()
		"cyberninja":
			change_skin("CYBER_NINJA_SKIN")
		"whitemage":
			change_skin("WHITE_MAGE_SKIN")
		"defskin":
			change_skin("DEFAULT_SKIN")
# Utility functions

func toggle_shopping(value : bool ):
	is_shopping = value

func freeze_player(time : float):
	is_frozen = true
	velocity.y = 0
	yield(get_tree().create_timer(time), "timeout")
	is_frozen = false


func get_opals(opals : int):
	Global.opals_amount += opals
	emit_signal("opals_obtained", opals)
	emit_signal("record_opals_obtained", opals)
	

func add_shield_hp(value : float):
	shield_hp += value
	$Shield/ShieldHPBar.max_value = shield_hp
	$Shield/ShieldHPBar.value += shield_hp
# Timers
func _on_InvulnerabilityTimer_timeout():
	$HurtAnimationPlayer.play("RESET")
	if !is_dead:
		is_invulnerable = false
		$Sprite.play("Idle")
	
func _on_AttackTimer_timeout():
	$AttackCollision.position = Vector2(0,0)
#	$Sprite.position = Vector2(0,0)
	is_attacking = false
	$AttackCollision/CollisionShape2D.disabled = true
	$Sprite.play("Idle")

func _on_DashCooldown_timeout():
	is_dashing = false
	$Sprite.play("Idle")
	
func _on_KnockbackTimer_timeout():
	var repulsion : Vector2 = Vector2()
	is_knocked_back = false
	repulsion.x = knockback_power
	velocity.x = 0
	

func _on_KnockbackCooldownTimer_timeout():
	is_knocked_back = false
	can_be_knocked = true
#	Input.action_release("left")
#	Input.action_release("right")

func _on_DashUseTimer_timeout():
	can_dash = true 

func _on_HealingTimer_timeout():
	is_healing = false
	if Global.healthpot_amount > 0:
		if Global.max_hearts - Global.hearts == 0.5:
			Global.hearts += 0.5
		else:
			Global.hearts += 1
		emit_signal("life_changed", Global.hearts)
		Global.healthpot_amount -= 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)

func _on_FullHealTimer_timeout():
	is_healing = false
	if Global.lifewine_amount > 0 and Global.hearts < Global.max_hearts:
		Global.hearts += Global.max_hearts - Global.hearts
		emit_signal("life_changed", Global.hearts, Global.current_character)
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana, Global.current_character)
		Global.lifewine_amount -= 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)

func _on_ManaHealTimer_timeout():
	is_healing = false
	if Global.manapot_amount > 0 and Global.mana < Global.max_mana:
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana, Global.current_character)
		Global.manapot_amount -= 1
		emit_signal("manapot_obtained", Global.manapot_amount)
func _on_AnimationPlayer_animation_finished(anim_name):
	$SwordSprite.visible = false
func _on_GlideTimer_timeout():
	if is_gliding and glider_equipped:
		Global.mana -= 1
		emit_signal("mana_changed", Global.mana, Global.current_character)

	if Global.mana >= 1 and glider_equipped:
		$GlideTimer.start()
	else:
		is_gliding = false
		Input.action_release("jump")
	
func _on_MeleeTimer_timeout():
	pass # Replace with function body.
func _on_OxygenTimer_timeout():
	$OxygenBar.value -= 5
	if underwater:
		$OxygenTimer.start()
func _on_OxygenRefillTimer_timeout():
	if !underwater and $OxygenBar.value < 100 and $OxygenTimer.is_stopped():
		$OxygenBar.value += 10
		$OxygenRefillTimer.start()

func on_campfire_toggled():
	is_healing = true
	$CampfireTimer.start()

func _on_CampfireTimer_timeout():
	Global.hearts += Global.max_hearts - Global.hearts
	emit_signal("life_changed", Global.hearts)
	is_healing = false


func _on_AirborneTimer_timeout():
	Input.action_release("ui_attack")
	velocity.y = 0
	airborne_mode = false



func _on_EnemyEvasionArea_area_exited(area):
	if Global.current_character == "Player":
		if is_dashing and area.is_in_group("Hostile"):
			is_invulnerable = true
			
			Input.action_release("ui_attack")
			emit_signal("perfect_dash")
			Engine.time_scale = 0.5
			yield(get_tree().create_timer(0.1), "timeout")
			Engine.time_scale = 1.0
			if $TempusTardusTriggerCD.is_stopped():
				var tempus_targus = TEMPUS_TARGUS.instance()
				get_parent().add_child(tempus_targus)
				tempus_targus.position = global_position
				$TempusTardusTriggerCD.start()
	#		knock_airborne(area, 4)
	#		Input.action_press("jump")
	#		
			
			yield(get_tree().create_timer(2), "timeout")
	#		Input.action_release("jump")
	#		airborne_mode = true
#			is_invulnerable = false
		elif !is_dashing and area.is_in_group("Enemy"):
			perfect_dash = false
		



func _on_EnemyEvasionArea_area_entered(area):
	if area.is_in_group("Hostile"):
		perfect_dash = true



func _on_AttackCollision_area_exited(area):
	if area.is_in_group("Enemy"):
		attack_area_overlaps_enemy = false
		

func update_energy_meter(value : int):
	$EnergyMeter.value += value
	$EnergyMeter.visible = true
	$HideEnergyMeterTimer.start()
	if $EnergyMeter.value == $EnergyMeter.max_value:
		if !energy_full:
			$EnergyMeterFlickerEffectPlayer.play("Flicker")
			energy_full = true
		$EnergyMeter.texture_progress = MAXED_ENERGY_METER
	else:
		$EnergyMeter.texture_progress = ENERGY_METER

func _on_InputPressTimer_timeout():
	if !Input.is_action_pressed("ui_dash") and !is_quickswap_attacking and !mobility_lock:
		if Input.is_action_pressed("ui_up") and is_on_floor():
			upwards_charged_attack()
		if Input.is_action_pressed("ui_down") and airborne_mode and !is_on_floor():
			downwards_charged_attack()
		
		elif !Input.is_action_pressed("ui_up"):

			if $EnergyMeter.value >= Global.player_skill_multipliers["SlashFlurryEnergyCost"]:
				# Some rank-ups may increase the max value of the energy meter
				charged_attack("Special")
				$EnergyMeter.value -= Global.player_skill_multipliers["SlashFlurryEnergyCost"]
			else:
				if airborne_mode:
					if !is_flurry_attacking and !is_dash_counter_attacking:
						thrust_attack()
				else:
					if is_on_floor():
						charged_attack("Circular") if attack_string_count == 1 and Global.player_talents["CycloneSlashes"]["unlocked"] and Global.player_talents["CycloneSlashes"]["enabled"] else charged_attack("Ground")

func _on_DashInputPressTimer_timeout():
	if Global.current_character == "Player" and !mobility_lock and Input.is_action_pressed("ui_dash") and !Input.is_action_pressed("ui_attack") and !is_quickswap_attacking:
		charged_dash()

func _on_WalkParticleTimer_timeout():
	if is_on_floor() and Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		print(velocity.x)
		var walkparticle = WALK_PARTICLE.instance()
		walkparticle.emitting = true
		get_parent().add_child(walkparticle)
		walkparticle.position = $ParticlePosition.global_position


func _on_KatanaSheatheWindowTimer_timeout():
	is_sheathing = false


func _on_AirborneMaxDuration_timeout():
	Input.action_release("ui_attack")
	velocity.y = 0
	airborne_mode = false



func _on_GhostTrailTimer_timeout():
	if is_dashing:
		if Global.current_character == "Player" and velocity.x != 0:
			var ghost_trail = preload("res://scenes/misc/GhostTrail.tscn").instance()
			
			if $Sprite.frames == DEFAULT_SKIN:
				ghost_trail.texture = preload("res://assets/characters/player/player_idle.png")
				ghost_trail.scale.x = 5
				ghost_trail.scale.y = 5
			elif $Sprite.frames == CYBER_NINJA_SKIN:
				ghost_trail.texture = preload("res://assets/characters/player/skins/cyber_ninja/player_idle.png")
				ghost_trail.scale.x = 6
				ghost_trail.scale.y = 6
			elif $Sprite.frames == WHITE_MAGE_SKIN:
				ghost_trail.texture = preload("res://assets/characters/player/skins/white_mage/player_idle.png")
				ghost_trail.scale.x = 6
				ghost_trail.scale.y = 6
			get_parent().add_child(ghost_trail)
			ghost_trail.position = global_position
			if !$Sprite.flip_h:
				ghost_trail.flip_h = false
			else:
				ghost_trail.flip_h = true
				




func _on_ResetAttackStringTimer_timeout():
	attack_string_count = 4



func _on_SwitchAttackCollision_area_exited(area):
	if area.is_in_group("Enemy"):
		attack_area_overlaps_enemy = false
		


func _on_SwitchAttackCollision_area_entered(area):
	if weakref(area).get_ref() != null:
			if area.is_in_group("Enemy")  and !$AttackCollision/CollisionShape2D.disabled:
				print(attack_string_count)
				if !is_on_floor() and !$HeightRaycast2D.is_colliding():
					airborne_mode = true
					$AirborneTimer.stop()
					$AirborneTimer.start()
				attack_area_overlaps_enemy = true
	#			attack_knock()
	#			freeze_enemy()
				if Global.current_character == "Player":
					if weakref(area).get_ref() != null:
						var slashparticle = SWORD_SLASH_EFFECT.instance()
						var hitparticle = SWORD_HIT_PARTICLE.instance()
						get_parent().add_child(slashparticle)
						get_parent().add_child(hitparticle)
						hitparticle.emitting = true
						hitparticle.position = area.global_position
						slashparticle.position = area.global_position
						slashparticle.regular_slash_animation()
		

func _on_StabAttackCollision_area_entered(area):
	pass # Replace with function body.


func _on_StabAttackCollision_area_exited(area):
	if area.is_in_group("Enemy"):
		attack_area_overlaps_enemy = false

func _on_HideEnergyMeterTimer_timeout():
	pass
#	$EnergyMeter.visible = false


func _on_DashCounterAttackDelayTimer_timeout():
	is_dash_counter_attacking = false
