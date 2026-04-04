class_name DPSTestDummyGoblin extends Goblin


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RegenTimer.start()
	$SpearThrustAttackCollision.visible = false
	max_HP = 99999
	HP = max_HP
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func health_regen():
	pass


func _on_RegenTimer_timeout():
	heal(max_HP)
