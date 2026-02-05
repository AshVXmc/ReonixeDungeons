class_name MainMenu extends Control

func _ready():
	get_tree().set_auto_accept_quit(false)
	$Popup1.visible = false
	$SaveLabel.visible = false
#	print(InputMap.get_action_list("ui_use")[0].as_text())


func _process(delta):
	$NewGame.text = "> New game" if $NewGame.is_hovered() else "New game" 
	$LoadGame.text = "> Load game" if $LoadGame.is_hovered() else "Load game"
	$SetKeybinds.text = "> Controls" if $SetKeybinds.is_hovered() else "Controls"
	$Tutorial.text = "> How to play" if $Tutorial.is_hovered() else " How to play"
	$Exit.text = "> Exit" if $Exit.is_hovered() else "Exit"
	

func _on_NewGame_pressed():
	new_game()
	Global.delete_save_file()
func new_game():
	Global.reset_player_data()
	Global.reset_chest_data()
	$SceneTransition/ColorRect.visible = true
	$SceneTransition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/hublevel/HubLevel.tscn")
	call_deferred('free')


func _on_LoadGame_pressed():
	var savefile : File = File.new()
	if savefile.file_exists(Global.savepath):
		var error = savefile.open(Global.savepath, File.READ)
		if error == OK:
			# PLAYER DATA IS in here
			$LoadDataHelper.load_data(savefile)
			###
			$SceneTransition/ColorRect.visible = true
			$SceneTransition.transition()
			yield(get_tree().create_timer(1), "timeout")
			get_tree().change_scene(Global.levelpath)
		else:
			$SaveLabel.visible = true
			yield(get_tree().create_timer(2), "timeout")
			$SaveLabel.visible = false
	else:
		$SaveLabel.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$SaveLabel.visible = false
		
func _on_HowToPlay_pressed():
	get_tree().change_scene("res://scenes/menus/HowToPlayMenu_1.tscn")
	call_deferred('free')


func _on_Exit_pressed():
	get_tree().quit()





func _on_Tutorial_pressed():
	Global.reset_player_data()
	$SceneTransition/ColorRect.visible = true
	$SceneTransition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/TutorialLevel.tscn")
	call_deferred('free')


func _on_SetKeybinds_pressed():
	get_tree().change_scene("res://scenes/menus/SetKeybinds.tscn")
	call_deferred('free')


func _on_Credits_pressed():
	get_tree().change_scene("res://scenes/menus/CreditsUI.tscn")
	call_deferred('free')
