class_name GuardianGolem extends Goblin

const ENEMY_SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/EnemyShockwave.tscn")
const ENERGY_GRENADE : PackedScene = preload("res://scenes/enemies/GuardianGolemEnergyGrenade.tscn")
onready var player : Player = get_parent().get_node("Player")
enum state  {
	IDLE,
	WALKING,
	PUNCHING,
	STOMPING
}
enum {
	LEFT = -1, RIGHT = 1
}
var current_state setget set_current_state, get_current_state
func set_current_state(new_value : int):
	current_state = new_value
func get_current_state() -> int:
	return current_state

func _ready():
	max_HP_calc = 60 + (Global.enemy_level_index * 20)
	level_calc = round(Global.enemy_level_index)
	max_HP = max_HP_calc
	HP = max_HP
	level = level_calc
	atk_value = 2.25 * Global.enemy_level_index + 1
	MAX_SPEED = 75
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
	$Sprite.play("Idle")
	set_current_state(state.WALKING)
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value
	$Sprite.visible = true
	$Sprite.self_modulate = Color(1,1,1,1)
	$DeathSprite.visible = false
	$DeathSprite.texture = null
	$PlayerDetector/CollisionShape2D.disabled = false
	
	

# OVERRIDE
func _physics_process(delta):
	if !$Sprite.flip_h:
		$PlayerDetector.set_scale(Vector2(1,1))
	else:
		$PlayerDetector.set_scale(Vector2(-1,1))
	if (MAX_SPEED * 0.6) >= velocity.x and velocity.x >= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		if !dead and !is_casting and get_current_state() == state.IDLE:
			$Sprite.play("Idle")
		if $Area2D.is_in_group("Hostile"):
			$Area2D.remove_from_group("Hostile") 
	else:
		yield(get_tree().create_timer(0.1), "timeout")
		if !dead and !is_casting and get_current_state() == state.WALKING:
			$Sprite.play("Attacking")
		if !$Area2D.is_in_group("Hostile"):
			$Area2D.add_to_group("Hostile")
	if get_current_state() == state.IDLE and !dead:
		$Sprite.play("Idle")
	if player in $PlayerDetector.get_overlapping_bodies() and get_current_state() != state.PUNCHING and get_current_state() != state.STOMPING and $AttackCooldownTimer.is_stopped():
		print("detected player")
		if !$Sprite.flip_h:
			attack(LEFT)
		else:
			attack(RIGHT)
	if get_current_state() == state.PUNCHING and !dead :
		velocity.x = 0
	if get_current_state() == state.STOMPING and !dead:
		velocity.x = 0

# OVERRIDE
func start_death_sequence():
	dead = true
	$Area2D/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$Left/CollisionShape2D.disabled = true
	$Right/CollisionShape2D.disabled = true
	is_casting = false
	$AnimationPlayer.play("Death")
#
	set_current_state(state.IDLE)
#	$Sprite.visible = false
	if !$Sprite.flip_h:
		$DeathSprite.flip_h = false
	else:
		$DeathSprite.flip_h = true

func attack(direction : int):
	if $AttackCooldownTimer.is_stopped():
		punch_attack()

# call this on the "_on_Sprite_animation_finished" function
func end_attack_animation(delay_in_seconds : float = 0):
	$Sprite.stop()
	set_current_state(state.WALKING)
	is_casting = false
	yield(get_tree().create_timer(delay_in_seconds), "timeout")

		
func stomp_attack():
	if get_current_state() != state.STOMPING and $Sprite.animation != "StompAttack":
		set_current_state(state.STOMPING)
		is_casting = true
		$Sprite.play("StompAttack")

func punch_attack(grenade_count : int = 2):
	if get_current_state() != state.PUNCHING and $Sprite.animation != "Punch":
		set_current_state(state.PUNCHING)
		is_casting = true
		$Sprite.play("Punch")
		
		while grenade_count > 0:
			var energy_grenade : GuardianGolemEnergyGrenade = ENERGY_GRENADE.instance()
			var direction : int = 1
			if !$Sprite.flip_h:
				direction = -1

			var distance : float = position.distance_to(player.position)
			energy_grenade.force_magnitude =  direction * (distance * (distance * 0.031)) 
			energy_grenade.atk_value = atk_value 
			get_parent().add_child(energy_grenade)
			energy_grenade.position = $EnergyGrenadeSummonPosition2D.global_position
			yield(get_tree().create_timer(0.35), "timeout")
			grenade_count -= 1

func _on_Sprite_animation_finished():
	if $Sprite.animation == "StompAttack" and !dead:
		$AttackCooldownTimer.start()
		$StrongJumpParticle.emitting = true
		yield(get_tree().create_timer(0.25), "timeout")
		if !dead:
			if !$Sprite.flip_h:
				summon_shockwave(direction)
				$StrongJumpParticle.position.x = -35
			else:
				summon_shockwave(-1 * direction)
				$StrongJumpParticle.position.x = 35
			end_attack_animation(0.5)
	if $Sprite.animation == "Punch" and !dead:
		$AttackCooldownTimer.start()
		end_attack_animation(0)
		
func summon_shockwave(direction : int):
	var enemy_shockwave = ENEMY_SHOCKWAVE.instance()
	enemy_shockwave.direction = direction
	enemy_shockwave.scale = Vector2(0.7,1)
	enemy_shockwave.speed *= 0.67
	enemy_shockwave.get_node("Area2D").add_to_group("Hostile")
	enemy_shockwave.get_node("Area2D").add_to_group(str(10))
	get_parent().add_child(enemy_shockwave)
	enemy_shockwave.position = Vector2(global_position.x + (-100 * direction), global_position.y + 10) 



# OVERRIDE
func knockback(knockback_coefficient : float = 1):
#	is_staggered = true
#	if $Sprite.flip_h:
#		velocity.x = -SPEED * knockback_coefficient
#	else:
#		velocity.x = SPEED * knockback_coefficient
#	$HurtTimer.start()
	pass


