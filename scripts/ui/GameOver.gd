class_name GameOver extends Control

signal game_over()
func _ready():
	# Kills all enemies after game over to prevent unexpected bugs 
	connect("game_over", get_parent().get_parent().get_node("DebugMenu/Control"), "clear_enemies")
	visible = false


func _on_RestartButton_pressed():
	Global.reset_player_data()
	get_tree().change_scene("res://scenes/levels/Level1.tscn")
#	queue_free()
	
func _process(delta):
	pass
#	if visible:
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_LoadSaveButton_pressed():
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
			Global.firesaw_unlocked = player_data["FireSawUnlocked"]
			Global.opened_chests = player_data["ChestOpened"]
			
			Global.max_item_storage = player_data["MaxItemStorage"]
			Global.lighting = player_data["Lighting"]
			Global.vsync = player_data["Vsync"]
			
			get_parent().get_parent().get_node("SceneTransition/ColorRect").visible = true
			get_parent().get_parent().get_node("SceneTransition").transition()
			yield(get_tree().create_timer(1), "timeout")
			visible = false
			get_tree().change_scene(player_data["Level"])
		else:
			$NoSaveData.visible = true
			yield(get_tree().create_timer(2), "timeout")
			$NoSaveData.visible = false
	else:
		$NoSaveData.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$NoSaveData.visible = false

func _on_ExitButton_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")


func _on_GameOver_visibility_changed():
	emit_signal("game_over")
