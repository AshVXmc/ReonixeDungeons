class_name BurningStatus extends Area2D

# if the burn stack reaches 0, the burning debuff will be applied.
onready var burn_stack = 100
onready var refresh_stack = 150
var burncalcarray : Array
var is_burning : bool = false
# Maximum duration of the burning effect. Enemy burning RES
# Ticks every 0.25 secs
onready var max_burn_duration = $DestroyedTimer.wait_time

func _ready():

	$BurningBar.value = 0
	$CollisionShape2D.disabled = true
	$BurningParticles.visible = false
	if !get_parent().is_in_group("BurnStack"):
		get_parent().add_to_group("Burnstack")

func reduce_burn_stack(stack : int):
	if !is_burning:
		burn_stack -= stack
		$BurningBar.value += stack
		if burn_stack <= 0:
			print("TOTAL DAMAGE :" + str(calculate_damage()))
		#	$CollisionShape2D.disabled = false
			is_burning = true
			$BurningParticles.visible = true
			$DamageTickTimer.start()
			$DestroyedTimer.start()

func _process(delta):
	if is_burning:
		$BurningBar.visible = true
		
		$BurningBar.value = ($DestroyedTimer.time_left / max_burn_duration * $BurningBar.max_value)

	
func _on_DamageTickTimer_timeout():
	if !$CollisionShape2D.disabled:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false


func _on_DestroyedTimer_timeout():
	queue_free()


#func _on_BurningStatus_area_entered(area):
#	if area.is_in_group("Frozen"):
#		pass

func calculate_damage():
	var sum : float 
	var total : float = burncalcarray.size()
	for b in burncalcarray:
		sum += b
	var mean = sum / total
	return mean

func _on_Detector_area_entered(area):
	if area.is_in_group("FireGauge"):
		burncalcarray.append(area.burncalculation)
		print(burncalcarray)
	if !is_burning:
		if area.is_in_group("FireGaugeOne"):
			reduce_burn_stack(25)
			
		elif area.is_in_group("FireGaugeTwo"):
			reduce_burn_stack(35)

#	elif is_burning:
#		if area.is_in_group("FireGaugeOne") and refresh_stack > 0:
#			refresh_stack -= 25
#			print(refresh_stack)
#		elif area.is_in_group("FireGaugeTwo") and refresh_stack > 0:
#			refresh_stack -= 35
#		if refresh_stack <= 0:
#			if area.is_in_group("FireGaugeOne") or area.is_in_group("FireGaugeTwo"):
#				$DestroyedTimer.start()
#				refresh_stack = 150
