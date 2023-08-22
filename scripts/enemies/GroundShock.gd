extends Node2D

const TYPE : String = "Shockwave"

func _ready():
	$DissapearTimer.start()
func _on_DissapearTimer_timeout():
	queue_free()
