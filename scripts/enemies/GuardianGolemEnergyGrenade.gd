class_name GuardianGolemEnergyGrenade extends RigidBody2D

# Set the force magnitude
export (int) var force_magnitude = 5000
export (float) var default_friction = 1

# NOTE
# This is summoned by guardian golems. If this grenade's
# collision mask 3 is active, it will break. Make sure mask 3 is OFF.

func _ready():
	friction = default_friction
	yield(get_tree().create_timer(0.15), "timeout")
	apply_force()

func apply_force():
	var force : Vector2 = Vector2(force_magnitude, 0)
	apply_impulse(Vector2.ZERO, force)
