class_name EnemyShockwave extends Area2D

const TYPE : String = "Shockwave"
const SPEED : int = 700
var velocity = Vector2()
var direction : int = 1
var elemental_type : String = "Physical"
var atk_value : float = 2 * Global.enemy_level_index + 1.25
const shockwave_texture : Texture = preload("res://assets/enemies/bosses/shockwave.png")
const slashwave_texture : Texture = preload("res://assets/misc/super_slash_projectile.png")
enum {
	SHOCKWAVE,
	SLASHWAVE
}
var form : int
func set_form(new_form : int) -> void:
	form = new_form
	match form:
		SHOCKWAVE:
			$Sprite.texture = shockwave_texture
		SLASHWAVE:
			$Sprite.texture = slashwave_texture
	if direction == 1:
		$Sprite.flip_h = true
	elif direction == -1:
		$Sprite.flip_h = false


func _physics_process(delta):
	velocity.x = SPEED * delta * -direction
	translate(velocity)
	

func _on_EnemyShockwave_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_DestroyedTimer_timeout():
	call_deferred('free')
