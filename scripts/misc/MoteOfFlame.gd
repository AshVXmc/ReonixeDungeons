class_name MoteOfFlame extends AnimatedSprite

# explosion damage is based on the player's ATK.
# damage is maybe halved or slightly reduced for the player?
var enemy_attack_value : int = 25

# for the player
var elemental_type : String = "Fire"
var atk_value : float = 7

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
#	call_deferred('free')

func _on_Timer_timeout():
	explode()
