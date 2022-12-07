class_name Goblin extends KinematicBody2D

const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")
const DEATH_SMOKE : PackedScene = preload("res://scenes/particles/DeathSmokeParticle.tscn")
onready var max_HP : int = Global.enemy_level_index * 200
onready var HP : int = max_HP
export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const MAX_SPEED : int = 160
var SPEED : int = MAX_SPEED
const MAX_GRAVITY : int = 45
var GRAVITY : int = MAX_GRAVITY
var is_staggered : bool = false
const LOOT = preload("res://scenes/items/LootBag.tscn")
onready var AREA_LEFT : Area2D = $Left
onready var AREA_RIGHT : Area2D = $Right
onready var PLAYER = get_parent().get_node("Player/Area2D")
onready var DECOY = get_parent().get_node("Decoy/Area2D")
onready var DECOY2 = get_parent().get_node("Decoy2/Area2D")
onready var DECOY3 = get_parent().get_node("Decoy3/Area2D")
var is_frozen : bool = false
var is_airborne : bool = false
var decoyed : bool = false
var dead : bool = false
const AIRBORNE_SPEED : int = -4000
export (int) var MAX_POISE = 100
export (int) var MIN_POISE = 0

export var Armored : bool = false
export (String, "Physical", "Magical", "Fire", "Ice", "Earth") var Armor_Type = "Physical"
export (int) var Armor_Durability = 100 # amount of poise/hits/elemental stacks needed to break the shield
export (float, 1.0) var Armor_Strength = 0.9 # total damage reduction the shield gives (0 is none, 1 is 100% reduction)

var poise : int = MAX_POISE / 2

var armor_strength_coefficient = 1 # default value so it doesn't throw an error
							

var phys_res : float = 25
var fire_res : float = 0
var earth_res : float = 0 
var ice_res : float = 0
var magic_res : float = -50
#var overlaps_enemy_while_midair : bool = false
var elemental_type : String = "Physical"
var atk_value : float = 0.25 * Global.enemy_level_index

func _ready():
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
func _physics_process(delta):
	if !is_airborne:
		set_collision_mask_bit(2, true)
	else:
		set_collision_mask_bit(2, false)
	if flipped:
		$Sprite.flip_h = true
	if !is_airborne:
		velocity.y += GRAVITY
#	if is_airborne:
#		velocity.y = 0
#		velocity.y -= 250
#		yield(get_tree().create_timer(1), "timeout")
#		velocity.y = 0
#	if !is_staggered and !is_frozen:
	velocity = move_and_slide(velocity, FLOOR)
	
	if velocity.x == 0:
		$Sprite.play("Idle")
		if $Area2D.is_in_group("Hostile"):
			$Area2D.remove_from_group("Hostile") 
	else:
		$Sprite.play("Attacking")
		if !$Area2D.is_in_group("Hostile"):
			$Area2D.add_to_group("Hostile")
	if is_on_floor():
		if !is_staggered and !is_frozen and !dead and !is_airborne and weakref(PLAYER).get_ref() != null: 
			if AREA_LEFT.overlaps_area(PLAYER) and !AREA_LEFT.overlaps_area(DECOY) and !AREA_LEFT.overlaps_area(DECOY2) and !AREA_LEFT.overlaps_area(DECOY3):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = -SPEED
			elif AREA_LEFT.overlaps_area(DECOY) or AREA_LEFT.overlaps_area(DECOY2) or AREA_LEFT.overlaps_area(DECOY):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = -SPEED 
			if AREA_RIGHT.overlaps_area(PLAYER) and !AREA_RIGHT.overlaps_area(DECOY) and !AREA_RIGHT.overlaps_area(DECOY2) and !AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = SPEED 
			elif AREA_RIGHT.overlaps_area(DECOY) or AREA_RIGHT.overlaps_area(DECOY2) or AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = SPEED
	else:
		if $Sprite.flip_h:
			velocity.x = -SPEED
		else:
			velocity.x = SPEED

	if is_staggered or is_frozen or is_airborne:
		velocity.x = 0
	
	
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
						var damage = round((raw_damage - (raw_damage * (phys_res / 100))) * armor_strength_coefficient)
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
						
						var damage = ((raw_damage - (raw_damage * (phys_res / 100))) * armor_strength_coefficient)
						print("HP reduced by " + str(damage))
						HP -= float(damage)
						$HealthBar.value  -= float(damage)
						add_damage_particles("Physical", float(damage))
						parse_damage()
						knockback()
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
		if area.is_in_group("SmallEleganceValue"):
			Global.elegance_meter += 8
		if area.is_in_group("MediumEleganceValue"):
			Global.elegance_meter += 12
		if area.is_in_group("LargeEleganceValue"):
			Global.elegance_meter += 8
		if area.is_in_group("FireGauge"):
			pass
		if area.is_in_group("Burning"):
			print("Burning")
			var damage = (0.025 * max_HP) + (Global.damage_bonus["fire_dmg_bonus_%"] / 100 * (0.025 * max_HP))
			HP -= damage
			Global.elegance_meter += 1
			print("HP-" + str(damage))
			$HealthBar.value -= damage
			parse_status_effect_damage()
			add_damage_particles("Fire", damage)
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
		
		if area.is_in_group("LightPoiseDamage"):
			pass
		if area.is_in_group("MediumPoiseDamage"):
			pass
		if area.is_in_group("HeavyPoiseDamage"):
			pass
	
#	if area.is_in_group("Enemy"):
#		set_collision_mask_bit(2, false)
#

func add_damage_particles(type : String, dmg : int):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.damage_type = type
	dmgparticle.damage = dmg
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position

func knockback(knockback_coefficient : float = 2.5):
	if $Sprite.flip_h:
		velocity.x = -SPEED * knockback_coefficient
	else:
		velocity.x = SPEED * knockback_coefficient
	print("Knocked back")
	
func armor_break():
	pass
func parse_damage():
	if poise < MAX_POISE:
		is_staggered = true
		$Sprite.set_modulate(Color(2,0.5,0.3,1))
	elif poise >= MAX_POISE:
		poise = MIN_POISE
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0:
		$Area2D/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		$Left/CollisionShape2D.disabled = true
		$Right/CollisionShape2D.disabled = true
		dead = true
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
		loot.Tier = 2
		loot.position = $Position2D.global_position
	queue_free()
	print("reached")
	Global.enemies_killed += 1

func parse_status_effect_damage():
	$Sprite.set_modulate(Color(2,0.5,0.3,1))
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0:
		$Area2D/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		$Left/CollisionShape2D.disabled = true
		$Right/CollisionShape2D.disabled = true
		dead = true
		$AnimationPlayer.play("Death")
		
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
