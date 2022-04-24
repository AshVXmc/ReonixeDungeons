extends Control

func on_player_common_monster_dust_obtained(player_common_monster_dust : int):
	if player_common_monster_dust == 0:
		$Label.visible = false
		$TextureRect.visible = false
	else:
		$Label.visible = true
		$TextureRect.visible = true
		$Label.text = str(player_common_monster_dust)
