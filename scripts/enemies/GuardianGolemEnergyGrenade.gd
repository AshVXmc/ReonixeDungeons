class_name GuardianGolemEnergyGrenade extends RigidBody2D

# Set the force magnitude
export (int) var force_magnitude = 5000
export (float) var default_friction = 1
var atk_value : float = 1
var elemental_type : String = "Physical"
const DETONATION_PARTICLE : PackedScene = preload("res://scenes/particles/GuardianGolemEnergyGrenadeDetonationParticle.tscn")
# NOTE
# This is summoned by guardian golems. If this grenade's
# collision mask 3 is active, it will break. Make sure mask 3 is OFF.

func _ready():
	friction = default_friction
	yield(get_tree().create_timer(0.15), "timeout")
	apply_force()
	start_detonation(0.5)
	$ExplosionArea2D/CollisionShape2D.disabled = true
	$ExplosionArea2D.add_to_group(str(atk_value))

func start_detonation(delay_in_secs_before_countdown : float):
	yield(get_tree().create_timer(delay_in_secs_before_countdown), "timeout")
	$AnimationPlayer.play("Flicker")
	$ExplodeTimer.start()
	
func apply_force():
	var force : Vector2 = Vector2(force_magnitude, 0)
	apply_impulse(Vector2.ZERO, force)

func explode():
	$EnergyGrenadeSprite.visible = false
	$EnergyGrenadeGlowingSprite.visible = false
	$AnimationPlayer.stop()
	$ExplosionArea2D/CollisionShape2D.disabled = false
	var particle : CPUParticles2D = DETONATION_PARTICLE.instance()
	get_parent().add_child(particle)
	particle.position = global_position
	particle.emitting = true
	yield(get_tree().create_timer(0.3), "timeout")
	call_deferred('free')
	particle.call_deferred('free')

func _on_ExplodeTimer_timeout():
	explode()
