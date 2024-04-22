class_name ChaosMagicUI extends Control

onready var player = get_parent().get_parent().get_node("Player")
const VERTICAL_JUMP_PARTICLE = preload("res://scenes/particles/VerticalJumpParticle.tscn") 

func _ready():
	chaos_magic(1)

func trigger_chaos_magic():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, 10)
	chaos_magic(num)

func chaos_magic(id : int):
	match id:
		1:
			# A gust of wind propels you upward. knocking enemies way
			$NinePatchRect/DescLabel.text = "A gust of wind pushes you upwards, pushing enemies away."
			$NinePatchRect.visible = true
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
			var vjp = VERTICAL_JUMP_PARTICLE.instance()
			get_parent().get_parent().add_child(vjp)
			vjp.position = player.global_position
			vjp.emitting = true
			vjp.get_node("StrongJumpParticle").emitting = true
			player.velocity.y = player.JUMP_POWER * 1.35
			yield(get_tree().create_timer(0.65), "timeout")
			vjp.call_deferred('free')
		2:
			pass
