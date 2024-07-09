class_name FrozenStatus extends Area2D

# if the freeze stack reaches 100, the frozen debuff will be applied.
onready var freeze_stack = 0
#var burn_immediately : bool = false
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
	$FreezeBar.value = freeze_stack
	if freeze_stack >= MAX_FREEZE_STACK and !is_frozen:
		
		$CollisionShape2D.disabled = false
		$Sprite.visible = true
		is_frozen = true
		$FreezeBar.visible = true
	if is_frozen:
		freeze_stack -= clamp(0, 3.5 , MAX_FREEZE_STACK)
	if is_frozen and freeze_stack <= 0:
		is_frozen = false
		freeze_stack = 0
		call_deferred('free')



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
