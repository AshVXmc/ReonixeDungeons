class_name BurningStatus extends Area2D

# if the burn stack reaches 0, the burning debuff will be applied.
onready var burn_stack = 100

func _ready():
	$CollisionShape2D.disabled = true
	$BurningParticles.visible = false
	if !get_parent().is_in_group("BurnStack"):
		get_parent().add_to_group("Burnstack")

func reduce_burn_stack(stack : int):
	burn_stack -= stack
	if burn_stack <= 0:
#		$CollisionShape2D.disabled = false
		$BurningParticles.visible = true
		$DamageTickTimer.start()
		$DestroyedTimer.start()
	
func _on_DamageTickTimer_timeout():
	if !$CollisionShape2D.disabled:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false


func _on_DestroyedTimer_timeout():
	queue_free()
	print("destroyed")


func _on_BurningStatus_area_entered(area):
	if area.is_in_group("Frozen"):
		queue_free()


func _on_Detector_area_entered(area):
	if area.is_in_group("FireGauge1"):
		reduce_burn_stack(25)
	elif area.is_in_group("FireGauge2"):
		reduce_burn_stack(50)
