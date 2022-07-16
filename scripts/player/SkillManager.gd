class_name SkillManager extends Node2D

signal mana_changed(amount)
const FIREBALL : PackedScene = preload("res://scenes/skills/Fireball.tscn")
const FIRESAW : PackedScene = preload("res://scenes/skills/FireSaw.tscn")
const FIRE_PARTICLE : PackedScene = preload("res://scenes/particles/FlameParticle.tscn")
const FIRE_FAIRY : PackedScene = preload("res://scenes/skills/FireFairy.tscn")
func _ready():
	connect("mana_changed", get_parent().get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")

func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			get_parent().is_using_primary_skill = true
			var firesaw = FIRESAW.instance()
			var fireparticle = FIRE_PARTICLE.instance()
			get_parent().add_child(firesaw)
			get_parent().add_child(fireparticle)
			fireparticle.emitting = true
			fireparticle.one_shot = false
			if !Global.godmode:
				Global.mana -= 4
				emit_signal("mana_changed", Global.mana)
			get_parent().is_attacking = false
			get_parent().get_node("AttackCollision/CollisionShape2D").disabled = true
			# 8 is the duration of the firesaw
			yield(get_tree().create_timer(firesaw.get_node("DestroyedTimer").wait_time),"timeout")
			get_parent().is_using_primary_skill = false
			get_parent().remove_child(fireparticle)
		"FireFairy":
			get_parent().is_using_secondary_skill = true
			var fire_fairy = FIRE_FAIRY.instance()
			get_parent().get_parent().add_child(fire_fairy)
			fire_fairy.position = get_parent().global_position
			if !Global.godmode:
				Global.mana -= 3
				emit_signal("mana_changed", Global.mana)
			yield(get_tree().create_timer(fire_fairy.get_node("DestroyedTimer").wait_time), "timeout")
			get_parent().is_using_secondary_skill = false
		"Fireball":
			get_parent().get_node("RangedAttackTimer").start()
			var fireball : Fireball = FIREBALL.instance()
			# warning-ignore:standalone_ternary
			fireball.flip_projectile(-1) if sign(get_parent().get_node("Position2D").position.x) == -1 else fireball.flip_projectile(1)	
			get_parent().get_parent().add_child(fireball)
			fireball.position = get_parent().get_node("Position2D").global_position
			if !Global.godmode:
				Global.mana -= 1
				emit_signal("mana_changed", Global.mana)
			get_parent().is_attacking = false
			get_parent().get_node("AttackCollision/CollisionShape2D").disabled = true
