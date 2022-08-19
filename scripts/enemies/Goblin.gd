class_name Goblin extends KinematicBody2D

const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")
const DEATH_SMOKE : PackedScene = preload("res://scenes/particles/DeathSmokeParticle.tscn")
onready var max_HP : int = Global.enemy_level_index * 40
onready var HP : int = max_HP
export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
var SPEED : int = 250
const GRAVITY : int = 45
var is_staggered : bool = false
const LOOT = preload("res://scenes/items/LootBag.tscn")
onready var AREA_LEFT : Area2D = $Left
onready var AREA_RIGHT : Area2D = $Right
onready var PLAYER = get_parent().get_node("Player/Area2D")
onready var DECOY = get_parent().get_node("Decoy/Area2D")
var is_frozen : bool = false
var is_airborne : bool = false
var decoyed : bool = false
var dead : bool = false

var phys_res : float = 25
var fire_res : float = 0 
var earth_res : float = 0 
var ice_res : float = 0


func _ready():
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value
func _physics_process(delta):
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
	$Sprite.play("Idle") if velocity.x == 0 else $Sprite.play("Attacking")
	if !is_staggered and !is_frozen and !dead and !is_airborne: 
		if AREA_LEFT.overlaps_area(PLAYER) and !AREA_LEFT.overlaps_area(DECOY):
			$Sprite.flip_h = false
			if !$Sprite.flip_h:
				yield(get_tree().create_timer(0.5),"timeout")
				velocity.x = -SPEED
		elif AREA_LEFT.overlaps_area(DECOY):
			$Sprite.flip_h = false
			if !$Sprite.flip_h:
				yield(get_tree().create_timer(0.25),"timeout")
				velocity.x = -SPEED 
		if AREA_RIGHT.overlaps_area(PLAYER) and !AREA_RIGHT.overlaps_area(DECOY):
			$Sprite.flip_h = true
			if $Sprite.flip_h:
				yield(get_tree().create_timer(0.5),"timeout")
				velocity.x = SPEED 
		elif AREA_RIGHT.overlaps_area(DECOY):
			$Sprite.flip_h = true
			if $Sprite.flip_h:
				yield(get_tree().create_timer(0.25),"timeout")
				velocity.x = SPEED

	if is_staggered or is_frozen or is_airborne:
		velocity.x = 0
	
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		var groups : Array = area.get_groups()
		for group_names in groups:
			if groups.has("Sword"):
				groups.erase("Sword")
			if groups.has("physics_process"):
				groups.erase("physics_process")
			if !groups.has("Sword") and !groups.has("physics_process"):
				var raw_damage = float(groups.max())
				var damage = round((raw_damage - (raw_damage * (phys_res / 100))))
				print("HP reduced by " + str(damage))
				HP -= float(damage)
				$HealthBar.value  -= float(damage)
				add_damage_particles("Physical", float(damage))
				parse_damage()
				break
	if area.is_in_group("SwordCharged"):
		var groups : Array = area.get_groups()
		for group_names in groups:
			if groups.has("SwordCharged"):
				groups.erase("SwordCharged")
			if groups.has("physics_process"):
				groups.erase("physics_process")
			if !groups.has("SwordCharged") and !groups.has("physics_process"):
				var raw_damage = float(groups.max())
				var damage = (raw_damage - (raw_damage * (phys_res / 100)))
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
			if groups.has("FireGauge1"):
				groups.erase("FireGauge1")
			if groups.has("FireGauge2"):
				groups.erase("FireGauge2")
			if groups.has("LightKnockback"):
				groups.erase("LightKnockback")
			if groups.has("physics_process"):
				groups.erase("physics_process")
			if !groups.has("Fireball") and !groups.has("FireGauge1") and !groups.has("physics_process"):
				print("HP reduced by " + str(groups.max()))
				HP -= float(groups.max())
				$HealthBar.value  -= float(groups.max())
				add_damage_particles("Fire", float(groups.max()))
				if area.is_in_group("LightKnockback"):
					parse_status_effect_damage()
				else:
					parse_damage()
				break
	if area.is_in_group("Burning"):
		var damage = (0.025 * max_HP) + (Global.damage_bonus["fire_dmg_bonus_%"] / 100 * (0.025 * max_HP))
		HP -= damage
		$HealthBar.value -= damage
		parse_status_effect_damage()
		add_damage_particles("Fire", damage)
	if area.is_in_group("Airborne"):
		is_airborne = true
		velocity.y = -1250
		yield(get_tree().create_timer(0.05), "timeout")
		velocity.y = 0
	if area.is_in_group("Player"):
		is_staggered = true
		yield(get_tree().create_timer(1), "timeout")
		is_staggered = false
	if area.is_in_group("Frozen"):
		is_frozen = true

func add_damage_particles(type : String, dmg : int):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.damage_type = type
	dmgparticle.damage = dmg
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position

func knockback():
	if $Sprite.flip_h:
		velocity.x = -SPEED * 5
	else:
		velocity.x = SPEED * 5
	print("Knocked back")
	
func parse_damage():
	is_staggered = true
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
func death():
	$Sprite.visible = false
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
	if area.is_in_group("Frozen"):
		is_frozen = false
	if area.is_in_group("Airborne"):
		is_airborne = false
