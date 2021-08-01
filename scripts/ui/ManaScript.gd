extends Control

const TYPE : String = "ManaPot"
var size : int = 48

func on_player_mana_changed(player_mana : int):
	$ManaIcon.rect_size.x = size * player_mana
	
