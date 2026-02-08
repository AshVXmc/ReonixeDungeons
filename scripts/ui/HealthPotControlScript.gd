extends Control

func on_player_healthpot_obtained(player_healthpot : int):
	$Label.visible = true
	$TextureRect.visible = true
	$Label.text = str(player_healthpot)
