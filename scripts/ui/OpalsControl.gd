extends Control

func on_player_opals_obtained(player_opals : int):
	$Label.visible = true
	$TextureRect.visible = true
	$Label.text = str(player_opals)


