class_name WinterQueen extends Particles2D

const FROZEN : PackedScene = preload("res://scenes/status_effects/FrozenStatus.tscn")

func _ready():
	emitting = false
	$Area2D/CollisionShape2D.disabled = true
	$FreezeGaugeArea/CollisionShape2D.disabled = true
	$Area2D.add_to_group(str(Global.glaciela_skill_multipliers["WinterQueen"] / 100 * Global.glaciela_attack))
	
	yield(get_tree().create_timer(1), "timeout")
	blizzard()
func blizzard():
	$AnimationPlayer.play("Idle")
	emitting = true
	yield(get_tree().create_timer(0.35), "timeout")
	$DestroyedTimer.start()
	$Area2D/CollisionShape2D.disabled = false
	$FreezeGaugeArea/CollisionShape2D.disabled = false
	$DamageTickTimer.start()
	

func destroy():
	emitting = false
	yield(get_tree().create_timer(1), "timeout")
	$DamageTickTimer.stop()
	$Area2D/CollisionShape2D.disabled = true
	$FreezeGaugeArea/CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.15), "timeout")
	call_deferred('free')


func _on_DamageTickTimer_timeout():
	$Area2D/CollisionShape2D.disabled = false if $Area2D/CollisionShape2D.disabled else true
	$FreezeGaugeArea/CollisionShape2D.disabled = false if $FreezeGaugeArea/CollisionShape2D.disabled else true


func _on_DestroyedTimer_timeout():
	destroy()
