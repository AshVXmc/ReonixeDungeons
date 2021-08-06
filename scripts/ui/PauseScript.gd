extends Control

var notpaused : bool = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if notpaused:
			get_tree().paused = true
			notpaused = false
			visible = true
			
func _on_ResumeButton_pressed():
	get_tree().paused = false
	notpaused = true
	visible = false


func _on_SaveButton_pressed():
	Global.save_player_data()
	if !$CenterContainer4/Saved.visible:
		$CenterContainer4/Saved.visible = true
		yield(get_tree().create_timer(1.5), "timeout")
		$CenterContainer4/Saved.visible = false

func _on_QuitButton_pressed():
	if !notpaused:
		get_tree().paused = false
		get_tree().change_scene("res://scenes/menus/MainMenu.tscn")



