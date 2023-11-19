class_name CharacterTalentTreeUI extends Control




func initialize_ui():
	visible = true
	update_talent_tree_ui()
	get_tree().paused = true
	
func update_talent_tree_ui():
	pass



func _on_CloseButtonMainUI_pressed():
	visible = false
	get_tree().paused = false







func _on_PlayerTalentButton1_pressed():
	if !Global.player_talents["CycloneSlashes"]:
		Global.player_talents["CycloneSlashes"] = true
		$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton.disabled = true
		$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton/ButtonLabel.text = "Bought"
		$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton/ButtonLabel.add_color_override("font_color", Color(1, 0.84, 0.01, 1))
func _on_PlayerTalentButton2_pressed():
	if !Global.player_talents["SwiftThrust"]:
		Global.player_talents["SwiftThrust"] = true
		$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton.disabled = true
		$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton/ButtonLabel.text = "Bought"
		$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton/ButtonLabel.add_color_override("font_color", Color(1, 0.84, 0.01, 1))





func _on_PlayerTalentButton3_pressed():
	pass # Replace with function body.


func _on_PlayerTalentButton4_pressed():
	pass # Replace with function body.
