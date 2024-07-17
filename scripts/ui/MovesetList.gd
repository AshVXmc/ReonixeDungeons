extends Control


func _ready():
	visible = false
	# "replace" is case sensitive. "replacen" isn't.
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("ATK", "[color=#ffd073]" + InputMap.get_action_list("ui_attack")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("DOWN", "[color=#ffd073]" + InputMap.get_action_list("ui_down")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("ATK", "[color=#ffd073]" + InputMap.get_action_list("ui_attack")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("DOWN", "[color=#ffd073]" + InputMap.get_action_list("ui_down")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("TUNDRA_SIGIL_MAX_STACKS", str(Global.glaciela_skill_multipliers["MaxTundraStars"]))
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("SP_ATK_1_BOOST", str(Global.glaciela_skill_multipliers["TundraStarsIceDamageBonus"]))

	update_moveset_list_text("Player")
	
func update_moveset_list_text(selected_character : String):
	match selected_character:
		"Player":
			$PlayerMovesetList.visible = true
			$GlacielaMovesetList.visible = false
		"Glaciela":
			$PlayerMovesetList.visible = false
			$GlacielaMovesetList.visible = true


func _on_CloseButton_pressed():
	visible = false
	get_parent().get_node("Pause").visible = true


func _on_PlayerTextureButton_pressed():
	update_moveset_list_text("Player")

func _on_GlacielaTextureButton_pressed():
	update_moveset_list_text("Glaciela")

func _on_AgnetteTextureButton_pressed():
	update_moveset_list_text("Agnette")
