extends Node2D

const SPEED : int = 120

var play : bool = false
func _process(delta):
	if play:
		$Path2D/PathFollow2D.offset += SPEED * delta
		$Path2D2/PathFollow2D.offset += SPEED * delta
	
