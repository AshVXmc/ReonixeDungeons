class_name MaskedGoblinSwordProjectile extends Area2D

const SPEED : float = 0.5
var velocity : Vector2 = Vector2(0,0)
var elemental_type : String = "Physical"
var atk_value : float = 0 # to be set by the masked goblin.

func _physics_process(delta):
	velocity.y += SPEED
	translate(velocity)

func _on_MaskedGoblinSwordProjectile_area_entered(area):
	if area.is_in_group("Player"):
		call_deferred('free')

func _on_MaskedGoblinSwordProjectile_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')
