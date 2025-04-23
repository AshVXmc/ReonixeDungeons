extends Control

onready var player_moveset_text : String = $PlayerMovesetList.bbcode_text
onready var glaciela_moveset_text : String = $GlacielaMovesetList.bbcode_text
onready var agnette_moveset_text : String = $AgnetteMovesetList.bbcode_text

func _ready():
	visible = false
	# "replace" is case sensitive. "replacen" isn't.
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("ATK", "[color=#ffd073]" + InputMap.get_action_list("ui_attack")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("DOWN", "[color=#ffd073]" + InputMap.get_action_list("ui_down")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("DASH", "[color=#ffd073]" + InputMap.get_action_list("ui_dash")[0].as_text() + "[/color]")
	$PlayerMovesetList.bbcode_text = $PlayerMovesetList.bbcode_text.replace("FC_CD", str(Global.player_skill_multipliers["FireCharmCD"]))
	
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("ATK", "[color=#ffd073]" + InputMap.get_action_list("ui_attack")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("DOWN", "[color=#ffd073]" + InputMap.get_action_list("ui_down")[0].as_text() + "[/color]")
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("TUNDRA_SIGIL_MAX_STACKS", str(Global.glaciela_skill_multipliers["MaxTundraStars"]))
	$GlacielaMovesetList.bbcode_text = $GlacielaMovesetList.bbcode_text.replace("SP_ATK_1_BOOST", str(Global.glaciela_skill_multipliers["TundraStarsIceDamageBonus"]))
	
	$AgnetteMovesetList.bbcode_text = $AgnetteMovesetList.bbcode_text.replace("ATK", "[color=#ffd073]" + InputMap.get_action_list("ui_attack")[0].as_text() + "[/color]")
	$AgnetteMovesetList.bbcode_text = $AgnetteMovesetList.bbcode_text.replace("UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
	$AgnetteMovesetList.bbcode_text = $AgnetteMovesetList.bbcode_text.replace("DOWN", "[color=#ffd073]" + InputMap.get_action_list("ui_down")[0].as_text() + "[/color]")
	$AgnetteMovesetList.bbcode_text = $AgnetteMovesetList.bbcode_text.replace("DASH", "[color=#ffd073]" + InputMap.get_action_list("ui_dash")[0].as_text() + "[/color]")
	
	update_player_talents_info_text()
	update_glaciela_talents_info_text()
	
	
	$PlayerMovesetList.visible = true
	$GlacielaMovesetList.visible = false
	$AgnetteMovesetList.visible = false

func _on_CloseButton_pressed():
	visible = false
	get_parent().get_node("Pause").visible = true


func update_player_talents_info_text():
	# restore the moveset text to default
	$PlayerMovesetList.bbcode_text = player_moveset_text
	
	for key in Global.player_talents_data.keys():
		if key == "TalentSlots" or key == "MaxTalentSlots":
			continue
		if Global.player_talents[key]["enabled"]:
			$PlayerMovesetList.append_bbcode("[color=#ffd703]" + Global.player_talents[key]["name"] + "[/color] ")
			$PlayerMovesetList.append_bbcode("(" + str(Global.player_talents[key]["description"]) + ")")
			$PlayerMovesetList.append_bbcode("\n\n")

func update_glaciela_talents_info_text():
	# restore the moveset text to default
	$GlacielaMovesetList.bbcode_text = glaciela_moveset_text
	
	for key in Global.glaciela_talents.keys():
		if key == "TalentSlots" or key == "MaxTalentSlots":
			continue
		if Global.glaciela_talents[key]["enabled"]:
			$GlacielaMovesetList.append_bbcode("[color=#ffd703]" + Global.glaciela_talents[key]["name"] + "[/color] ")
			$GlacielaMovesetList.append_bbcode("(" + str(Global.glaciela_talents[key]["description"]) + ")")
			$GlacielaMovesetList.append_bbcode("\n\n")


func _on_PlayerTextureButton_pressed():
	$PlayerMovesetList.visible = true
	$GlacielaMovesetList.visible = false
	$AgnetteMovesetList.visible = false


func _on_GlacielaTextureButton_pressed():
	$GlacielaMovesetList.visible = true
	$PlayerMovesetList.visible = false
	$AgnetteMovesetList.visible = false

func _on_AgnetteTextureButton_pressed():
	$AgnetteMovesetList.visible = true
	$PlayerMovesetList.visible = false
	$GlacielaMovesetList.visible = false
