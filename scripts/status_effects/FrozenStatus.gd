class_name FrozenStatus extends Area2D

# if the freeze stack reaches 100, the frozen debuff will be applied.
onready var freeze_stack = 0
#var burn_immediately : bool = false
const MAX_FREEZE_STACK = 1000
export (bool) var is_frozen : bool = false

# Maximum duration of the freeze effect
onready var max_freeze_duration 

func _ready():
	$FreezeBar.visible = false
	$FreezeBar.value = $FreezeBar.min_value
	# max freeze duration is based on glaciela's attack.
	# at level 1, her attack power is 20.
	max_freeze_duration = 0.2 * Global.glaciela_attack

		
func _process(delta):
	$FreezeBar.value = freeze_stack
	if freeze_stack >= MAX_FREEZE_STACK and !is_frozen:
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
	call_deferred('free')


func _on_Detector_area_entered(area):
	if area.is_in_group("IceGauge"):
		var groups : Array = area.get_groups()
		groups.erase("IceGauge")
		var ice_stack = int(groups[0])
		if !is_frozen:
			ice_stack += clamp(ice_stack, 0, MAX_FREEZE_STACK)
		else:
			# fire gauges that replenish an already depleting bar is only half as effective
			ice_stack += clamp(ice_stack / 2, 0, MAX_FREEZE_STACK)
		$FreezeBar.value = ice_stack
