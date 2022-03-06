extends Control

func _ready():
	$Popup1.visible = false
	$SaveLabel.visible = false

func _on_NewGame_pressed():
	new_game()

func new_game():
	Global.reset_player_data()
	Global.reset_chest_data()
	$SceneTransition/ColorRect.visible = true
	$SceneTransition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/Level1.tscn")
	queue_free()

func _on_LoadGame_pressed():
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
			Global.opals_amount = player_data["Opals"]
			Global.crystals_amount = player_data["RevivementCrystals"]
			Global.healthpot_amount = player_data["Healthpot"]
			Global.dash_unlocked = player_data["DashUnlocked"]
			Global.glide_unlocked = player_data["GlideUnlocked"]
			Global.opened_chests = player_data["ChestOpened"]
			Global.max_item_storage = player_data["MaxItemStorage"]
			Global.lighting = player_data["Lighting"]
			Global.vsync = player_data["Vsync"]
			$SceneTransition/ColorRect.visible = true
			$SceneTransition.transition()
			yield(get_tree().create_timer(1), "timeout")
			get_tree().change_scene(Global.levelpath)
	else:
		$SaveLabel.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$SaveLabel.visible = false
func _on_HowToPlay_pressed():
	get_tree().change_scene("res://scenes/menus/HowToPlayMenu.tscn")
	queue_free()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Yes_pressed():
	new_game()


func _on_No_pressed():
	$Popup1.visible = false
