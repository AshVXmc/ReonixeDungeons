class_name PerfectDash extends Control

func _ready():
	visible = false
func trigger_perfect_dash_animation():
	print("perfect dash")
	$AnimationPlayer.play("PerfectDashAnim")
	
