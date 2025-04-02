class_name FrozenStatus extends Area2D

# if the freeze stack reaches MAX_FREEZE_STACK, the frozen debuff will be applied.
onready var freeze_stack = 0
const MAX_FREEZE_STACK = 1000
export (bool) var is_frozen : bool = false



# Maximum duration of the freeze effect
# unused
onready var max_freeze_duration 

func _ready():
	pass

		
func _process(delta):
	if freeze_stack == 0:
		$FreezeBar.visible = false
	else:
		$FreezeBar.visible = true
	$FreezeBar.value = freeze_stack
	if freeze_stack >= MAX_FREEZE_STACK and !is_frozen:
		
		$CollisionShape2D.disabled = false
		$Sprite.visible = true
		is_frozen = true
		$FreezeBar.visible = true
	if is_frozen:
		freeze_stack -= clamp(0, 5 , MAX_FREEZE_STACK)
	if is_frozen and freeze_stack <= 0:
		is_frozen = false
		freeze_stack = 0
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
#		call_deferred('free')



func _on_FrozenStatus_area_entered(area):
	pass

func _on_DestroyedTimer_timeout():
	pass
#	call_deferred('free')


func _on_Detector_area_entered(area):
	if area.is_in_group("IceGauge"):
		var groups : Array = area.get_groups()
		groups.erase("IceGauge")
		var ice_gauge = int(groups[0])
		if !is_frozen:
			freeze_stack += clamp(ice_gauge, 0, MAX_FREEZE_STACK)
		else:
			# fire gauges that replenish an already depleting bar is only half as effective
			freeze_stack += clamp(ice_gauge / 2, 0, MAX_FREEZE_STACK)
		$FreezeBar.value = freeze_stack
	
	if is_frozen:
		if area.is_in_group("MediumPoiseDamage") or area.is_in_group("HeavyPoiseDamage"):
			shatter()



# deals ice damage in a small AoE and removes freeze.
# Cannot crit.
func shatter():
	var damage : float = 20 * Global.character_level_data["Glaciela"][0] + 12
	$ShatterDamageArea2D/CollisionShape2D.set_deferred("disabled", false)
	$ShatterDamageArea2D.add_to_group(str(damage))
	freeze_stack = 0
	is_frozen = false
	$AnimationPlayer.play("Shatter")
	yield(get_tree().create_timer(0.2), "timeout")
	$ShatterDamageArea2D/CollisionShape2D.set_deferred("disabled", true)
