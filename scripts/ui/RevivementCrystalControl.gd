extends Control

func on_player_crystal_obtained(player_crystal : int):
	if player_crystal == 0:
		$Label.visible = false
		$TextureRect.visible = false
	else:
		$Label.visible = true
		$TextureRect.visible = true
		$Label.text = str(player_crystal)
