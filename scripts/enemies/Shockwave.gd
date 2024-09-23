extends Area2D

const TYPE : String = "Shockwave"
const SPEED : int = 480
var velocity = Vector2()
onready var direction : int = 1

var hit_quota : int = Global.agnette_skill_multipliers["BearFormShockwaveMaxHits"]
func _ready():
	add_to_group(str(Global.agnette_attack * (Global.agnette_skill_multipliers["BearFormShockwave"] / 100)))
	
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	if direction == -1:
		$DirtParticles2D.rotation_degrees = -90




func _on_Shockwave_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')
	if body.is_in_group("EnemyEntity"):
		hit_quota -= 1
		if hit_quota <= 0:
			call_deferred('free')

func _on_DestroyedTimer_timeout():
	call_deferred('free')



