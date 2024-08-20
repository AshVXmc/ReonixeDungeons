class_name GroundedStatus extends Area2D

onready var grounded_stack = 0
#var burn_immediately : bool = false
const MAX_GROUNDED_STACK = 1000
export (bool) var is_grounded = false
export (float) var damage_shred = 40.0 # percentage

func _process(delta):
	if grounded_stack == 0:
		$GroundedBar.visible = false
	else:
		$GroundedBar.visible = true
	$GroundedBar.value = grounded_stack
	if grounded_stack >= MAX_GROUNDED_STACK and !is_grounded:
		apply_grounded_status()
		$GroundedParticles.emitting = true
		is_grounded = true
		$GroundedBar.visible = true
	if is_grounded:
		grounded_stack -= clamp(0, 5 , MAX_GROUNDED_STACK)
	if is_grounded and grounded_stack <= 0:
		is_grounded = false
		grounded_stack = 0
		$GroundedParticles.emitting = false
		remove_grounded_status()
	
func _on_Detector_area_entered(area):
	if area.is_in_group("EarthGauge"):
		var groups : Array = area.get_groups()
		groups.erase("EarthGauge")
		var earth_gauge = int(groups[0])
		if !is_grounded:
			grounded_stack += clamp(earth_gauge, 0, MAX_GROUNDED_STACK)
		else:
			# fire gauges that replenish an already depleting bar is only half as effective
			grounded_stack += clamp(earth_gauge / 2, 0, MAX_GROUNDED_STACK)
		$GroundedBar.value = grounded_stack

func apply_grounded_status():
	get_parent().debuff_damage_multiplier += damage_shred / 100

func remove_grounded_status():
	get_parent().debuff_damage_multiplier -= damage_shred / 100
	
func _on_GroundedStatus_area_entered(area):
	pass # Replace with function body.
