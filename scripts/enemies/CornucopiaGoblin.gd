class_name CornucopiaGoblin extends KinematicBody2D

var HP : int = 20
onready var hb_full = preload("res://assets/UI/healthbar_full.png")
onready var hb_half = preload("res://assets/UI/healthbar_half.png")
onready var hb_critical = preload("res://assets/UI/healthbar_critical.png")
const SMOKE_PARTICLE = preload("res://scenes/particles/SmokeParticle.tscn")
const GREEN_FRUIT = preload("res://scenes/enemies/bosses/GreenFruit.tscn")
const FROST_FRUIT = preload("res://scenes/enemies/bosses/FrostFruit.tscn")

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
const FLOOR = Vector2(0, -1)
var SPEED : int = 200
const GRAVITY : int = 45
var is_idling :bool = false

onready var healthbar = get_parent().get_node("BossHealth/Control/HealthBar")

func _ready():
	$AnimatedSprite.play("default")
	healthbar.texture_progress = hb_full
	$AttackTimer.start()

func _physics_process(delta):
	# Healthbar UI update
	healthbar.texture_progress = hb_full
	if healthbar.value < healthbar.max_value * 0.75:
		healthbar.texture_progress = hb_half
	if healthbar.value < healthbar.max_value * 0.4:
		healthbar.texture_progress = hb_critical
	if HP <= 0:
		queue_free()
	# Main movement code
	if flipped:
		$AnimatedSprite.flip_h = true
	velocity.y += GRAVITY
	$AnimatedSprite.play("default")
	if !is_idling:
		velocity = move_and_slide(velocity, FLOOR)
		if $Left.overlaps_area(PLAYER):
			$AnimatedSprite.flip_h = false
			if !$AnimatedSprite.flip_h and !is_idling:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = -SPEED
			if velocity.x == 0:
				velocity.x = SPEED * 2
		if $Right.overlaps_area(PLAYER):
			$AnimatedSprite.flip_h = true
			if $AnimatedSprite.flip_h and !is_idling:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = SPEED
			if velocity.x == 0:
				velocity.x = -SPEED * 2
	if is_idling:
		velocity.x = 0

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball"):
		HP -= 1
		healthbar.value -= 1
#	if area.is_in_group("UpwardAttack"):
#		pass
		

func shoot_green_fruits():
	var green_fruit : GreenFruit = GREEN_FRUIT.instance()
	var smoke_particle = SMOKE_PARTICLE.instance()
	# Smoke particles for when the horn fires
	get_parent().add_child(smoke_particle)
	smoke_particle.emitting = true
	smoke_particle.one_shot = true
	smoke_particle.position = $HornPosition.global_position
	get_parent().add_child(green_fruit)
	if $AnimatedSprite.flip_h:
		green_fruit.flip_projectile(1)
	green_fruit.position = $HornPosition.global_position
	$AttackTimer.start()


func shoot_frost_fruits():
	var frost_fruit : FrostFruit = FROST_FRUIT.instance()
	var smoke_particle = SMOKE_PARTICLE.instance()
	# Smoke particles for when the horn fires
	get_parent().add_child(smoke_particle)
	smoke_particle.emitting = true
	smoke_particle.one_shot = true
	smoke_particle.position = $HornPosition.global_position
	get_parent().add_child(frost_fruit)
	if $AnimatedSprite.flip_h:
		frost_fruit.flip_projectile(1)
	frost_fruit.position = $HornPosition.global_position
	$AttackTimer.start()

	
func _on_HurtTimer_timeout():
	is_idling = false


func _on_AttackTimer_timeout():
	if $Left.overlaps_area(PLAYER):
		$AnimatedSprite.flip_h = false
	elif $Right.overlaps_area(PLAYER):
		$AnimatedSprite.flip_h = true
	yield(get_tree().create_timer(0.25), "timeout")
	velocity.x = 0
	is_idling = true
	shoot_green_fruits()
	yield(get_tree().create_timer(1), "timeout")	
	shoot_green_fruits()
	yield(get_tree().create_timer(1), "timeout")
	shoot_frost_fruits()
	is_idling = false

func _on_Left_area_exited(area):
	yield(get_tree().create_timer(1.2), "timeout")
	velocity.x = SPEED


func _on_Right_area_exited(area):
	yield(get_tree().create_timer(1.2), "timeout")
	velocity.x = -SPEED
