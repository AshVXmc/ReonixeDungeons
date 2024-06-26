class_name MoteOfFlame extends AnimatedSprite

# explosion damage is based on the party's average level. Calculated in the chaosmagic ui
# damage is maybe halved or slightly reduced for the player?
var enemy_attack_value : int 

# for the player
var elemental_type : String = "Fire"
var atk_value : float = 5 + (Global.enemy_level_index * 2)  # result: 12 if enemy level = 1

func _ready():
	$EnemyDamagerArea2D.add_to_group(str(enemy_attack_value))
	$PlayerDamagerArea2D.add_to_group(str(atk_value))
	
	play("default")
	yield(get_tree().create_timer($Timer.wait_time * 0.6), "timeout")
	$AnimationPlayer.play("flicker")
	
func explode():
	$AnimationPlayer.stop()
	self_modulate = Color(1,1,1,0)
	$FireDetonationParticle.emitting = true
	$SmokeParticle.emitting = true
	$EnemyDamagerArea2D/CollisionShape2D.disabled = false
	$PlayerDamagerArea2D/CollisionShape2D.disabled = false
	yield(get_tree().create_timer(0.85), "timeout")
	call_deferred('free')

func _on_Timer_timeout():
	explode()
