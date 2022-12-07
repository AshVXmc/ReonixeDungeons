class_name SwordSlashEffect extends Node2D

onready var rng = RandomNumberGenerator.new()
const DEFAULT_ANIM_DURATION : float = 0.1
const SMOKE_PARTICLE : PackedScene = preload("res://scenes/particles/SmokeParticle.tscn")

#func _ready():
#	regular_slash_animation()
#

func regular_slash_animation():
	$HorizontalSlashSprite.visible = false
	rng.randomize()
	var randint = rng.randi_range(1,4)
	match randint:
		1:
			$AnimationPlayer.play("SwordSlash1")
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
			call_deferred('free')
		2:
			$AnimationPlayer.play("SwordSlash2")
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
			call_deferred('free')
		3:
			$AnimationPlayer.play("SwordSlash3")
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
			call_deferred('free')
		4:
			$AnimationPlayer.play("SwordSlash4")
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
			call_deferred('free')
			
func horizontal_slash_animation():
	$SlashEffectPlayer.play("HorizontalSlash")
	
func flurry_slash_animation():
	$HorizontalSlashSprite.visible = false
	
	# Randomize the order of the blade slashes every time it is instanced
	var MIN = 5
	var MAX = 45
	
	$Sprite.position.x = generate_value(MIN, MAX)

	var speed_multiplier = 1.25
	$AnimationPlayer.playback_speed = speed_multiplier
	$AnimationPlayer.play("SwordSlash1")
	instance_particle()
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
	$Sprite.position.x = generate_value(MIN, MAX)
	

	$AnimationPlayer.play("SwordSlash2")
	instance_particle()
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
	$Sprite.position.x = generate_value(MIN, MAX)

	$AnimationPlayer.play("SwordSlash3")
	instance_particle()
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
	$Sprite.position.x = generate_value(MIN, MAX)
	instance_particle()
#	$Sprite.position.y = generate_value(MIN, MAX)
	$AnimationPlayer.play("SwordSlash4")
	instance_particle()
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
	instance_particle()
	call_deferred('free')

func instance_particle():
	var particle = SMOKE_PARTICLE.instance()
	particle.scale.x = 3
	particle.scale.y = 3
	particle.one_shot = true
	add_child(particle)
func generate_value(min_value : int, max_value : int):
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var rng = RNG.randi_range(min_value, max_value)
	return rng
