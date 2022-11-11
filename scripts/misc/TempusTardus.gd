class_name TempusTardus extends Area2D

var duration : float = 1.0

func _ready():
	yield(get_tree().create_timer(duration), "timeout")
	$AnimationPlayer.play("fadeout")

func destroy():
	call_deferred('free')
