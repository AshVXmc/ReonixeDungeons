extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
		queue_free()


func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
	queue_free()

