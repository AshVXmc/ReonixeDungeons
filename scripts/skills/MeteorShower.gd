class_name MeteorShower extends Node2D

var velocity = Vector2()
var SPEED = 650
var is_destroyed : bool = false

func _ready():
	$Area2D.add_to_group(str(Global.attack_power * (Global.player_talents["MeteorShower"]["damage"] / 100)))
	print($Area2D.get_groups())
	get_parent().get_node("Player").cam_shake = true
	
func _physics_process(delta):
	if !is_destroyed:
		velocity.y = SPEED * delta
		translate(velocity)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap") and $ExplosionDelayTimer.is_stopped():
		explode()

func explode():
	is_destroyed = true
	$Sprite.visible = false
	$ExplosionParticle.emitting = true
	$Area2D/CollisionShape2D.disabled = false
	$Trails.visible = false
	yield(get_tree().create_timer(0.75), "timeout")
	get_parent().get_node("Player").cam_shake = false
	call_deferred('free')
