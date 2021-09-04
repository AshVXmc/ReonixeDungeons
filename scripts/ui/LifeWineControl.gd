extends Control

func on_player_lifewine_obtained(player_lifewine : int):
	if player_lifewine == 0:
		$Label.visible = false
		$TextureRect.visible = false
	else:
		$Label.visible = true
		$TextureRect.visible = true
		$Label.text = str(player_lifewine)

