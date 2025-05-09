class_name SwordSlashEffect extends Node2D

onready var rng = RandomNumberGenerator.new()
const DEFAULT_ANIM_DURATION : float = 0.1
const SMOKE_PARTICLE : PackedScene = preload("res://scenes/particles/SmokeParticle.tscn")

func _ready():
	$HorizontalSlashSprite.visible = false

func regular_slash_animation():
	$HorizontalSlashSprite.visible = false
	$Sprite.visible = true
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
			
func horizontal_slash_animation(destroy_after_done : bool = true):
	$SlashEffectPlayer.play("HorizontalSlash")
	if destroy_after_done:
		yield(get_tree().create_timer(DEFAULT_ANIM_DURATION), "timeout")
		call_deferred('free')

func stop_all_animations():
	$AnimationPlayer.stop()
func circular_flurry_animation():
	$CircularFlurry.visible = true
	$SlashEffectPlayer.play("CircularFlurry")
	
func player_counter_attack_animation():
	$SlashEffectPlayer.play("X-slash")
func flurry_slash_animation(num):
	$HorizontalSlashSprite.visible = false
	
	# Randomize the order of the blade slashes every time it is instanced
	var MIN = -25
	var MAX = 25
	
	$Sprite.position.x = generate_value(MIN, MAX)
	$Sprite.position.y = generate_value(MIN, MAX)
	var speed_multiplier = 1.25
	$AnimationPlayer.playback_speed = speed_multiplier
	match num:
		1:
			$Sprite.visible = true
			scale.x = 2
			scale.y = 2
			$AnimationPlayer.play("SwordSlash1")
			instance_particle()
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
			$Sprite.position.x = generate_value(MIN, MAX)
			$Sprite.position.y = generate_value(MIN, MAX)
			yield(get_tree().create_timer(0.7), "timeout")
			call_deferred('free')
		2:
			$Sprite.visible = true
			scale.x = 2
			scale.y = 2
			$AnimationPlayer.play("SwordSlash2")
			instance_particle()
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
			$Sprite.position.x = generate_value(MIN, MAX)
			$Sprite.position.y = generate_value(MIN, MAX)
			
			yield(get_tree().create_timer(0.7), "timeout")
			call_deferred('free')
		3:
			$Sprite.visible = true
			scale.x = 2
			scale.y = 2
			$AnimationPlayer.play("SwordSlash3")
			instance_particle()
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
			$Sprite.position.x = generate_value(MIN, MAX)
			$Sprite.position.y = generate_value(MIN, MAX)
			
			yield(get_tree().create_timer(0.7), "timeout")
			call_deferred('free')
		4:
			$Sprite.visible = true
			scale.x = 2
			scale.y = 2
			$AnimationPlayer.play("SwordSlash4")
			instance_particle()
			yield(get_tree().create_timer(DEFAULT_ANIM_DURATION / speed_multiplier),"timeout")
			$Sprite.position.x = generate_value(MIN, MAX)
			$Sprite.position.y = generate_value(MIN, MAX)
			
			yield(get_tree().create_timer(0.7), "timeout")
			call_deferred('free')
		5:
			yield(get_tree().create_timer(0.5), "timeout")
			scale.x = 2
			scale.y = 2
			$HorizontalSlashSprite.visible = true
			$HorizontalSlashSprite.scale.x = 8
			$HorizontalSlashSprite.scale.y = 8
			$SlashEffectPlayer.play("HorizontalSlash")
			yield(get_tree().create_timer(0.2), "timeout")
			call_deferred('free')
			
func player_perfect_dash_counterattack_animation():
	$Sprite.visible = true
	$SlashEffectPlayer.play("HorizontalSlash")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION), "timeout")
	$AnimationPlayer.play("SwordSlash2")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION), "timeout")
	$AnimationPlayer.play("SwordSlash1")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION), "timeout")
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
