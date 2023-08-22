extends Control

func on_player_manapot_obtained(player_manapot : int):
	if player_manapot == 0:
		$Label.visible = false
		$TextureRect.visible = false
	else:
		$Label.visible = true
		$TextureRect.visible = true
		$Label.text = str(player_manapot)
