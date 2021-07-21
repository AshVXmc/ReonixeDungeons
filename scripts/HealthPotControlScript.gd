extends Control

func on_player_healthpot_obtained(player_healthpot : int):
	$Label.text = player_healthpot as String
	
