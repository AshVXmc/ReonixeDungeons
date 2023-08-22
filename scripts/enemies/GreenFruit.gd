class_name GreenFruit extends Area2D

const SPEED : int = 500
var velocity = Vector2()
var direction : int = -1
const GREEN_SPLAT_PARTICLE = preload("res://scenes/particles/GreenSplatParticle.tscn")
const LOOT = preload("res://scenes/items/LootBag.tscn")
var destroyed = false

func _ready():
	$AnimationPlayer.play("Spin")

func _physics_process(delta):
	if !destroyed:
		velocity.x = SPEED * delta * direction
		translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func flip_projectile(p_direction : int):
	direction = p_direction
	if p_direction == -1:
		$Sprite.flip_h = true

func _on_GreenFruit_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Fireball") or area.is_in_group("Sword"):
		destroyed = true
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
		var greensplatparticle = GREEN_SPLAT_PARTICLE.instance()
		get_parent().add_child(greensplatparticle)
		greensplatparticle.position = global_position
		greensplatparticle.emitting = true
		greensplatparticle.one_shot = true
#		yield(get_tree().create_timer(1), "timeout")
		queue_free()
