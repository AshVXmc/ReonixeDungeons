class_name PiercingProjectile extends Node2D

var SPEED : int = 850
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false

func _ready():
	$Area2D.add_to_group("Sword")
	$Area2D.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["PiercingProjectile"] / 100)))

func _physics_process(delta):
	if !destroyed:
		velocity.x = SPEED * delta * direction
		$AnimationPlayer.play("Shoot")
	else:
		velocity.x = 0
	translate(velocity)


func _on_DestroyedTimer_timeout():
	call_deferred('free')
