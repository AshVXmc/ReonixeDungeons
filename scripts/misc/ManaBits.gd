class_name ManaBits extends RigidBody2D

var possible_applied_force_x = [1500, -1500, 1000, -1000, 2000, -2000]
var mana_granted : float = 0.25

func _ready():
	set_applied_force(Vector2(apply_force_x(), 0))


func apply_force_x():
	randomize()
	var random_value = possible_applied_force_x[randi() % possible_applied_force_x.size()]
	return random_value


func _on_DestroyedTimer_timeout():
	call_deferred('free')


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		call_deferred('free')
