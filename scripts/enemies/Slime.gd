class_name Slime extends KinematicBody2D

var velocity : Vector2 = Vector2()
var max_HP : int = Global.enemy_level_index * 60
var HP : int = max_HP
var is_dead : bool = false 
var direction : int = 1
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
var SPEED : int = 100
const GRAVITY : int = 45
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
const FROZEN = preload("res://scenes/status_effects/FrozenStatus.tscn")
var is_frozen : bool = false
const DMG_INDICATOR : PackedScene = preload("res://scenes/particles/DamageIndicatorParticle.tscn")
var is_staggered : bool = false

func _ready():
	$HealthBar.max_value = max_HP
func _physics_process(delta):
	
	if direction == 1 and !is_dead:
		$AnimatedSprite.flip_h = false
	elif !is_dead:
		$AnimatedSprite.flip_h = true
	if !is_dead and !is_frozen and !is_staggered:
		velocity.x = SPEED * direction
		$AnimatedSprite.play("slimeanim")
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		if is_on_wall() or !$RayCast2D.is_colliding():
			direction *= -1
			$RayCast2D.position.x *= -1

func _on_Area2D_area_entered(area):
	var groups_to_remove : Array = [
		"Sword", "SwordCharged", "Fireball", "Ice",
		"physics_process", "FireGauge", "FireGaugeTwo", "LightKnockback"
	]
	if HP > 0:
		if area.is_in_group("Sword"):
			HP -= Global.attack_power
			$HealthBar.value -= Global.attack_power
			add_damage_particles("Physical", Global.attack_power)
			parse_damage()
		if area.is_in_group("SwordCharged"):
			HP -= Global.attack_power * 2
			$HealthBar.value -= Global.attack_power * 2
			add_damage_particles("Physical", Global.attack_power * 2)
			parse_damage()
		if area.is_in_group("Fireball"):
			HP -= Global.base_damage_taken * Global.skill_levels["FireballLevel"]
			$HealthBar.value -= Global.base_damage_taken * Global.skill_levels["FireballLevel"]
			add_damage_particles("Fire", Global.base_damage_taken * Global.skill_levels["FireballLevel"])
			parse_damage()
		if area.is_in_group("Burning"):
			var damage = (0.035 * max_HP) + (Global.damage_bonus["fire_dmg_bonus_%"] / 100 * (0.025 * max_HP))
			HP -= damage
			$HealthBar.value -= damage
			add_damage_particles("Fire", damage)
			parse_status_effect_damage()
		if area.is_in_group("Frozen"):
			is_frozen = true
		
	drop_loot()

func parse_damage():
	is_staggered = true
	$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
	$HurtTimer.start()
func parse_status_effect_damage():
	$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
	$HurtTimer.start()
func add_damage_particles(type : String, dmg : int):
	var dmgparticle = DMG_INDICATOR.instance()
	dmgparticle.damage_type = type
	dmgparticle.damage = dmg
	get_parent().add_child(dmgparticle)
	dmgparticle.position = global_position
	
func drop_loot():
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,2)
	if HP <= 0:
		if randomint == 1:
			get_parent().add_child(loot)
			loot.position = $Position2D.global_position
		queue_free()
		Global.enemies_killed += 1

func _on_HurtTimer_timeout():
	is_staggered = false
	velocity.x = SPEED * direction
	$AnimatedSprite.set_modulate(Color(1,1,1,1))
	


func _on_Area2D_area_exited(area):
	if area.is_in_group("Frozen"):
		is_frozen = false
