extends Control

func on_player_healthpot_obtained(player_healthpot : int):
	if player_healthpot == 0:
		$Label.visible = false
		$TextureRect.visible = false
	else:
		$Label.visible = true
		$TextureRect.visible = true
		$Label.text = str(player_healthpot)
