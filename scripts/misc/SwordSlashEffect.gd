class_name SwordSlashEffect extends Node2D

onready var rng = RandomNumberGenerator.new()
const DEFAULT_ANIM_DURATION : float = 0.1

func _ready():
	regular_slash_animation()


func regular_slash_animation():
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
			
func flurry_slash_animation():
	$AnimationPlayer.play("SwordSlash1")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
	$AnimationPlayer.play("SwordSlash2")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
	$AnimationPlayer.play("SwordSlash3")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
	$AnimationPlayer.play("SwordSlash4")
	yield(get_tree().create_timer(DEFAULT_ANIM_DURATION),"timeout")
	
	call_deferred('free')
