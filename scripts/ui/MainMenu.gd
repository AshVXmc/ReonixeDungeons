extends Control


func _on_NewGame_pressed():
	Global.reset_player_data()
	Global.reset_chest_data()
	$SceneTransition/ColorRect.visible = true
	$SceneTransition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/Level1.tscn")
	queue_free()

func _on_LoadGame_pressed():			# Load player data
	var savefile : File = File.new()
	if savefile.file_exists(Global.savepath):
		var error = savefile.open(Global.savepath, File.READ)
		if error == OK:
			var player_data : Dictionary = savefile.get_var()
			savefile.close()
			Global.max_hearts = player_data["MaxHealth"]
			Global.hearts = player_data["Health"]
			Global.max_mana = player_data["MaxMana"]
			Global.mana = player_data["Mana"]
			Global.healthpot_amount = player_data["Healthpot"]
			Global.dash_unlocked = player_data["DashUnlocked"]
			Global.glide_unlocked = player_data["GlideUnlocked"]
			Global.unopened_chests = player_data["ChestUnopened"]
			Global.player_position = player_data["PlayerPos"]
			$SceneTransition/ColorRect.visible = true
			$SceneTransition.transition()
			yield(get_tree().create_timer(1), "timeout")
			get_tree().change_scene("res://scenes/levels/" + player_data["Level"] + ".tscn")
	elif !savefile.file_exists(Global.savepath):
		print("NO SAVE DATA")

func _on_HowToPlay_pressed():
	get_tree().change_scene("res://scenes/menus/HowToPlayMenu.tscn")
	queue_free()


func _on_Exit_pressed():
	get_tree().quit()
