extends Control

var notpaused = true
	
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
			
func _on_button_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
					
	

