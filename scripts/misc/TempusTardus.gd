class_name TempusTardus extends Area2D

const duration = 5
onready var COOLDOWN_TIMER = get_parent().get_node("TempusTardusGlobalCD")

func _ready():
	$DestroyedTimer.start()
func refresh_duration():
	pass
	
	
	
	
func destroy():
	$AnimationPlayer.play("fadeout")


func _on_DestroyedTimer_timeout():
	destroy()
