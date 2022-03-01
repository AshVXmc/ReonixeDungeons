class_name Sign extends Node2D

func _ready():
	$ParallaxBackground/Background1.visible = true
	if Global.lighting:
		$Light2D.visible = true
	else:
		$Light2D.visible = false
	if Global.vsync:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false


	

	
