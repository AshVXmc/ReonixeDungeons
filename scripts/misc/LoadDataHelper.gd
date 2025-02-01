class_name LoadDataHelper extends Node2D


func load_data(savefile):
	var player_data : Dictionary = savefile.get_var()
	savefile.close()
	# IMPORTANT NOTE
	# When releasing new content make sure to add this:
	# if player_data.has("varname"):
	#		Global.varname = "varname
	# Its so older save files are compatible.
#			Global.max_hearts = player_data["MaxHealth"]
#			Global.hearts = player_data["Health"]
	Global.max_mana = player_data["MaxMana"]
	Global.mana = player_data["Mana"]
	Global.attack_power = player_data["AttackPower"]
	Global.opals_amount = player_data["Opals"]
	Global.crystals_amount = player_data["RevivementCrystals"]
	Global.healthpot_amount = player_data["Healthpot"]
	Global.drops_inventory["common_dust"] = player_data["CommonDust"]
	Global.drops_inventory["goblin_scales"] = player_data["GoblinScales"]
	Global.drops_inventory["bat_wings"] = player_data["BatWings"]
	Global.drops_inventory["sweet_herbs"] = player_data["SweetHerbs"]
	Global.opened_chests = player_data["ChestOpened"]
	Global.max_item_storage = player_data["MaxItemStorage"]
	Global.lighting = player_data["Lighting"]
	Global.vsync = player_data["Vsync"]
	Global.levelpath = player_data["Level"]
	Global.character_health_data = player_data["CharacterHealthData"]
	Global.character_defense_data = player_data["CharacterDefenseData"]
	Global.equipped_character_skins = player_data["EquippedSkins"]
	Global.player_talents_data = player_data["PlayerTalentsData"]
	Global.glaciela_talents_data = player_data["GlacielaTalentsData"]
	# agnette data
	Global.enemies_encountered_data = player_data["EnemiesEncounteredData"]
	Global.player_perks = player_data["PlayerPerks"]
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
	Global.character_level_data = player_data["CharacterLevelData"]
	Global.character_defense_data = player_data["CharacterDefenseData"]
