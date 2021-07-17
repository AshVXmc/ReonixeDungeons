extends Control

var notpaused : bool = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if notpaused:
			get_tree().paused = true
			notpaused = false
			visible = true
		else:
			get_tree().paused = false
			notpaused = true
			visible = false	 
		
	if Input.is_action_just_pressed("ui_exit") and !notpaused:
			get_tree().paused = false
			get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
			
			
