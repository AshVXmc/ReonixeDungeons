class_name SpikeTrap extends Node2D

signal add_mana_to_agnette(amount)
onready var mana_granted : float = 0.15

func _ready():
	connect("add_mana_to_agnette", get_parent().get_node("Player/CharacterManager/Agnette"), "change_mana_value")
	$DestroyedTimer.wait_time = Global.agnette_skill_multipliers["SpikeGrowthDuration"]
func _on_Timer_timeout():
	$Area2D/CollisionShape2D.disabled = true if !$Area2D/CollisionShape2D.disabled else false
	$GroundedGaugeArea/CollisionShape2D.disabled = true if !$GroundedGaugeArea/CollisionShape2D.disabled else false
	
	
func _on_DestroyedTimer_timeout():
	call_deferred('free')


func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		emit_signal("add_mana_to_agnette", mana_granted)
