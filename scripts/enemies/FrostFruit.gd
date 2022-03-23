class_name FrostFruit extends Area2D

const SPEED : int = 500
var velocity = Vector2()
var direction : int = -1
const FROST_SPLAT_PARTICLE = preload("res://scenes/particles/FrostSplatParticle.tscn")
var destroyed = false
signal freeze_player(time)
const LOOT = preload("res://scenes/items/LootBag.tscn")

func _ready():
	$AnimationPlayer.play("Spin")
	$FrostParticleTimer.start()
	
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
	if area.is_in_group("Fireball") or area.is_in_group("Sword"):
		destroyed = true
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
		add_particles()
		add_loot()
		queue_free()
	if area.is_in_group("Player"):
		destroyed = true
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
		add_particles()
		add_loot()
		connect("freeze_player", get_parent().get_node("Player"), "freeze_player" )
		emit_signal("freeze_player", 0.6)
		queue_free()

func add_loot():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var randomint = RNG.randi_range(1,5)
	if randomint == 1:
		var loot = LOOT.instance()
		get_parent().add_child(loot)
		loot.position = global_position
func add_particles():
	var frostsplatparticle = FROST_SPLAT_PARTICLE.instance()
	get_parent().add_child(frostsplatparticle)
	frostsplatparticle.position = global_position
	frostsplatparticle.emitting = true
	frostsplatparticle.one_shot = true
	
func _on_FrostParticleTimer_timeout():
	add_particles()
	$FrostParticleTimer.start()
