class_name Familiar extends Bat

func _ready():
	SPEED = 250


func _on_DeathTimer_timeout():
	
	queue_free()
