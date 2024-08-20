class_name EldritchHex extends Node2D

var atk_value : float = 0.45 *  Global.enemy_level_index + 1
var elemental_type = "Physical"
func _ready():
	$LightningAnimatedSprite.visible = false
	$Area2D/CollisionShape2D.disabled = true

	yield(get_tree().create_timer(1), "timeout")
	lighting_spell()

# maybe multiple ticks of damage? for AOE denial
func lighting_spell():
	$LightningAnimatedSprite.visible = true
	$LightningAnimatedSprite.play("strike")
	$Area2D/CollisionShape2D.disabled = false
	$DamageTickTimer.start()


func _on_DamageTickTimer_timeout():
	$Area2D/CollisionShape2D.disabled = false if $Area2D/CollisionShape2D.disabled else true


func _on_DestructionTimer_timeout():
	call_deferred('free')
