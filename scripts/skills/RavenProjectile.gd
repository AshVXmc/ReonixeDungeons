class_name RavenProjectile extends Area2D

const MAX_SPEED : int = 650
var SPEED : int = MAX_SPEED
var velocity := Vector2()
const TYPE = "Earth"
signal add_mana_to_agnette(amount)
onready var mana_granted : float = 0.15
var is_destroyed : bool = false
func _ready():
	connect("add_mana_to_agnette", get_parent().get_node("Player/CharacterManager/Agnette"), "change_mana_value")
	$Area2D.add_to_group(str(Global.agnette_attack * (Global.agnette_skill_multipliers["RavenFormBombardmentAttack"] / 100)))

func _physics_process(delta):
#	position += transform.x * SPEED * delta * x_direction
	if !is_destroyed:
		velocity.y = SPEED * delta 
		translate(velocity)

func detonate():
	is_destroyed = true
	# for some reason this doesn't work?  maybe cause its a polygon
#	$Area2D/CollisionPolygon2D.disabled = true
	$TrailParticles.visible = false
	$Sprite.visible = false
	$AnimationPlayer.play("default")
	$CollisionShape2D.disabled = true
	$ExplosionParticles.emitting = true
	yield(get_tree().create_timer(0.65), "timeout")
	call_deferred('free')

func _on_RavenProjectile_body_entered(body):
	if body.is_in_group("EnemyEntity") or body.is_in_group("Tilemap"):
		detonate()
