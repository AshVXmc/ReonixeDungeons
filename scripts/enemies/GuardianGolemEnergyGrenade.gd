class_name GuardianGolemEnergyGrenade extends RigidBody2D

# Set the force magnitude
export (int) var force_magnitude = 7000
export (float) var default_friction = 1



func _ready():
	friction = default_friction
	yield(get_tree().create_timer(0.15), "timeout")
	apply_force_(1)

func apply_force_(t):
	var force : Vector2 = Vector2(force_magnitude, 0)
	apply_impulse(Vector2.ZERO, force)
