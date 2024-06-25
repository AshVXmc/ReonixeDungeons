class_name BurningStatus extends Area2D

# if the burn stack reaches 100, the burning debuff will be applied.
onready var burn_stack = 0
var burn_immediately : bool = false
const MAX_BURN_STACK = 1000
const BURN_MULTIPLIER : float = 0.15
export (bool) var is_burning : bool = false
# Maximum duration of the burning effect. Enemy burning RES
# Ticks every 0.25 secs
onready var max_burn_duration = $DestroyedTimer.wait_time


func _ready():
	if burn_immediately:
		burn_immediately()
	$CollisionShape2D.disabled = true
	$BurningParticles.visible = false
	# based on the player's attack power
	add_to_group(str(Global.attack_power * BURN_MULTIPLIER))
	if !get_parent().is_in_group("BurnStack"):
		get_parent().add_to_group("Burnstack")




func burn_immediately():
	is_burning = true
	burn_stack = MAX_BURN_STACK
	

func _process(delta):
	$BurningBar.value = burn_stack
	if burn_stack >= MAX_BURN_STACK and !is_burning:
		is_burning = true
		$BurningParticles.visible = false
		$BurningBar.visible = true
	if is_burning:
		burn_stack -= clamp(0, 3.5 , MAX_BURN_STACK)
		$BurningParticles.visible = true

	if is_burning and burn_stack <= 0:
		is_burning = false
		burn_stack = 0
		call_deferred('free')


func _on_DamageTickTimer_timeout():
	if is_burning:
		if !$CollisionShape2D.disabled:
			$CollisionShape2D.disabled = true
		else:
			$CollisionShape2D.disabled = false


func _on_DestroyedTimer_timeout():
	call_deferred('free')
	get_parent().remove_from_group("Burnstack")



func _on_Detector_area_entered(area):
	if area.is_in_group("FireGauge"):
		var groups : Array = area.get_groups()
		groups.erase("FireGauge")
		var fire_gauge = int(groups[0])
		if !is_burning:
			burn_stack += clamp(fire_gauge, 0, MAX_BURN_STACK)
		else:
			# fire gauges that replenish an already depleting bar is only half as effective
			burn_stack += clamp(fire_gauge / 2, 0, MAX_BURN_STACK)
		$BurningBar.value = burn_stack

