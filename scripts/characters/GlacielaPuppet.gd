class_name GlacielaPuppet extends Node2D
var JUMP_PARTICLE = preload("res://scenes/particles/StrongJumpParticle.tscn")

func _ready():
	$AnimatedSprite.play("Default")

func add_particle():
	var jp = JUMP_PARTICLE.instance()
	get_parent().add_child(jp)
	jp.emitting = true
	jp.position = $ParticlePosition.global_position
	$AnimatedSprite.stop()
