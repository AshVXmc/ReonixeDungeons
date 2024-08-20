class_name FireSlime extends Slime



func _ready():
	$AnimatedSprite.visible = true
	$ExplosionArea2D/CollisionShape2D.disabled = true
	damage_immunity.fire = true
	elemental_type = "Fire"
	atk_value = 2 * Global.enemy_level_index + 2

func parse_damage(staggers:bool = true):
	if staggers:
		is_staggered = true
	$AnimatedSprite.set_modulate(Color(1,0.5,0.3,1))
	$HurtTimer.start()
	if HP <= 0:
		drop_loot()
		death()

func parse_status_effect_damage():
	$AnimatedSprite.set_modulate(Color(1,0.5,0.3,1))
	$HurtTimer.start()
	
func death():
	is_dead = true
#	call_deferred('free')
#	Global.enemies_killed += 1
	self_destruct()
	
func self_destruct():
	$Area2D.remove_from_group("Hostile")
	$AnimatedSprite.speed_scale = 4.0
	$AnimatedSprite.play("slimeanim")
	$AnimationPlayer.play("explode")
	SPEED = 0
	yield(get_tree().create_timer(1), "timeout")
	$FireDetonationParticle.emitting = true
#	$AnimatedSprite.visible = false
	$ExplosionArea2D/CollisionShape2D.disabled = false
	yield(get_tree().create_timer(0.4), "timeout")
	$AnimatedSprite.stop()
	$AnimationPlayer.stop()
	$AnimatedSprite.play("dead")
	$AnimationPlayer.play("Death")
	var deathparticle = DEATH_SMOKE.instance()
	deathparticle.emitting = true
	deathparticle.position = global_position
	get_parent().add_child(deathparticle)
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred('free')
	Global.enemies_killed += 1
