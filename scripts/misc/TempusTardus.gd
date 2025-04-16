class_name TempusTardus extends Area2D

const duration = 5
onready var COOLDOWN_TIMER = get_parent().get_node("TempusTardusGlobalCD")

func _ready():
	$DestroyedTimer.start()
	if get_parent().is_in_group("LevelHasStageTimer"):
		get_parent().time_slow_coefficient = get_parent().TEMPUS_TARDUS_TIMESLOW

func destroy():
	if get_parent().is_in_group("LevelHasStageTimer"):
		get_parent().time_slow_coefficient = 1
	$AnimationPlayer.play("fadeout")

func _on_DestroyedTimer_timeout():
	destroy()
