class_name MainMenu extends Control

func _ready():
	$Popup1.visible = false
	$SaveLabel.visible = false

func _process(delta):
	$NewGame.text = "> New game" if $NewGame.is_hovered() else "New game" 
	$LoadGame.text = "> Load game" if $LoadGame.is_hovered() else "Load game"
	$HowToPlay.text = "> How to play" if $HowToPlay.is_hovered() else "How to play"
	$Logs.text = "> Update logs" if $Logs.is_hovered() else "Update logs"
	$Exit.text = "> Exit" if $Exit.is_hovered() else "Exit"
func _on_NewGame_pressed():
	new_game()

func new_game():
	Global.reset_player_data()
	Global.reset_chest_data()
	$SceneTransition/ColorRect.visible = true
	$SceneTransition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/HubLevel.tscn")
	queue_free()


func _on_LoadGame_pressed():
	var savefile : File = File.new()
	if savefile.file_exists(Global.savepath):
		var error = savefile.open(Global.savepath, File.READ)
		if error == OK:
			var player_data : Dictionary = savefile.get_var()
			savefile.close()
			# IMPORTANT NOTE
			# When releasing new content make sure to add this:
			# if player_data.has("varname"):
			#		Global.varname = "varname
			# Its so older save files are compatible.
			Global.max_hearts = player_data["MaxHealth"]
			Global.hearts = player_data["Health"]
			Global.max_mana = player_data["MaxMana"]
			Global.mana = player_data["Mana"]
			Global.attack_power = player_data["AttackPower"]
			Global.opals_amount = player_data["Opals"]
			Global.crystals_amount = player_data["RevivementCrystals"]
			Global.healthpot_amount = player_data["Healthpot"]
			Global.common_monster_dust_amount = player_data["CommonMonsterDust"]
			Global.goblin_scales_amount = player_data["GoblinScales"]
			Global.dash_unlocked = player_data["DashUnlocked"]
			Global.glide_unlocked = player_data["GlideUnlocked"]
			Global.opened_chests = player_data["ChestOpened"]
			Global.max_item_storage = player_data["MaxItemStorage"]
			Global.lighting = player_data["Lighting"]
			Global.vsync = player_data["Vsync"]
			Global.levelpath = player_data["Level"]
			Global.enemies_killed = player_data["EnemiesKilled"]
			Global.player_position = player_data["PlayerPosition"]
			Global.unlocked_characters = player_data["UnlockedCharacters"]
			Global.current_character = player_data["CurrentCharacter"]
			Global.equipped_characters = player_data["EquippedCharacters"]
			Global.player_skill_multipliers = player_data["PlayerSkillMultipliers"]
			Global.glaciela_skill_multipliers = player_data["GlacielaSkillMultipliers"]
			Global.is_loading_a_save = player_data["IsLoadingASave"]
			Global.masked_goblin_defeated = player_data["MaskedGoblinDefeated"]
			Global.activated_portals = player_data["ActivatedPortals"]
			Global.enemy_level_index = player_data["EnemyLevelIndex"]
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
	queue_free()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Yes_pressed():
	new_game()


func _on_No_pressed():
	$Popup1.visible = false


func _on_Logs_pressed():
	get_tree().change_scene("res://scenes/menus/Logs.tscn")
	queue_free()
