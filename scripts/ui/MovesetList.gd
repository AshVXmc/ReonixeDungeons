extends Control


func _ready():
	# "replacen" is case sensitive. "replace" isn't.
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replacen("ATK", "[color=#ffd073]" + InputMap.get_action_list("ui_attack")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replacen("UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
	
	



func _on_CloseButton_pressed():
	visible = false
	get_parent().get_node("Pause").visible = true
