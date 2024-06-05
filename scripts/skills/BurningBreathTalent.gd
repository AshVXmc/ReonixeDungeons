class_name BurningBreathTalent extends Node2D

func _ready():
	$DestroyTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DestroyTimer_timeout():
	call_deferred('free')
