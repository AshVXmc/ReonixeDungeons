extends Control

func on_player_goblin_scales_obtained(player_goblin_scales : int):
	if player_goblin_scales == 0:
		$Label.visible = false
		$TextureRect.visible = false
	else:
		$Label.visible = true
		$TextureRect.visible = true
		$Label.text = str(player_goblin_scales)
