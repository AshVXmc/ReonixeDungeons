extends Control

func _ready():
	$OpalsObtainedLabel.visible = false

func on_player_opals_obtained(player_opals : int, amount_added : int):
	$Label.visible = true
	$TextureRect.visible = true
	$Label.text = str(player_opals)
	$OpalsObtainedLabel.visible = true
	$OpalsObtainedLabel.text = "+" + str(amount_added)
	yield(get_tree().create_timer(1.5), "timeout")
	$OpalsObtainedLabel.visible = false



