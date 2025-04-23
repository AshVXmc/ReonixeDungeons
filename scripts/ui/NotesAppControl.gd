class_name NotesAppControl extends Control


var notes_dict : Dictionary

onready var player : Player = get_parent().get_parent().get_parent().get_parent().get_node("Player")
onready var description_textbox : RichTextLabel = get_node("DescriptionBoxNinePatchRect/Textbox_ScrollContainer/VBoxContainer/Control/RichTextLabel")
onready var description_header : RichTextLabel = get_node("DescriptionBoxNinePatchRect/Textbox_ScrollContainer/VBoxContainer/Control/Header")


# read tutorial text from a JSON file.
func _ready():
	var notes_info = File.new()
	notes_info.open("res://scripts/jsondata/NotesAppInfo.json", File.READ)
	notes_dict = parse_json(notes_info.get_as_text())

func initialize_ui():
	visible = true
	get_parent().layer = 5
	player.is_shopping = true
	
func close_ui():
	visible = false
	get_parent().layer = 1
	player.is_shopping = false
	get_parent().call_deferred('free')
	


func set_description_textbox_content(new_content : String):
	description_textbox.bbcode_text = new_content
func set_description_header_content(new_header : String):
	description_header.bbcode_text = new_header
func set_scrollcontainer_back_to_top():
	$DescriptionBoxNinePatchRect/Textbox_ScrollContainer.scroll_vertical = $DescriptionBoxNinePatchRect/Textbox_ScrollContainer.get_v_scrollbar().max_value

func _on_TutorialMovement_TextureButton_pressed():
	set_description_header_content(notes_dict["TutorialMovement"]["Header"])
	set_description_textbox_content(
		notes_dict["TutorialMovement"]["Description"]
		+ "\n\n" + str("[color=#5DA271]Left[/color]: [color=#ffd703]%s[/color], [color=#5DA271]Right[/color]: [color=#ffd703]%s[/color]" % [InputMap.get_action_list("left")[0].as_text(), InputMap.get_action_list("right")[0].as_text()])
		+ "\n" + str("[color=#5DA271]Jump[/color]: [color=#ffd703]%s[/color]" % InputMap.get_action_list("jump")[0].as_text())
		+ "\n" + str("[color=#5DA271]Double Jump[/color]: [color=#ffd703]%s[/color] in mid-air. Consumes [color=#89F336]Stamina[/color]." % InputMap.get_action_list("jump")[0].as_text())
		+ "\n" + str("[color=#5DA271]Dash[/color]: [color=#ffd703]%s[/color]. Consumes [color=#89F336]Stamina[/color]. Dashes backwards if standing still. [color=#ffd703]%s[/color] while moving to dash in your facing direction." % [InputMap.get_action_list("ui_dash")[0].as_text(), InputMap.get_action_list("ui_dash")[0].as_text()])
	)
	set_scrollcontainer_back_to_top()
	print($Choices_NinePatchRect/Choices_ScrollContainer.get_v_scrollbar())

func _on_CombatPart1_TextureButton_pressed():
	set_scrollcontainer_back_to_top()
	set_description_header_content(notes_dict["CombatPart1"]["Header"])
	set_description_textbox_content(
		notes_dict["CombatPart1"]["Description"]
		+ "\n\n" + notes_dict["CombatPart1"]["Description2"]
		+ "\n\n" + notes_dict["CombatPart1"]["Description3"]
	)
	

func _on_CombatPart2_TextureButton_pressed():
	set_scrollcontainer_back_to_top()
	set_description_header_content(notes_dict["CombatPart2"]["Header"])
	set_description_textbox_content(
		notes_dict["CombatPart2"]["Description"]
		+ "\n" + str("[color=#5DA271]Attack[/color]: [color=#ffd703]%s[/color]" % InputMap.get_action_list("ui_attack")[0].as_text())
		+ "\n" + str("[color=#5DA271]Charged Attack[/color]: Hold [color=#ffd703]%s[/color]" % InputMap.get_action_list("ui_attack")[0].as_text()) 
		+ "\n" + str("[color=#5DA271]Primary Skill/Ultimate[/color]: [color=#ffd703]%s[/color]" % InputMap.get_action_list("primary_skill")[0].as_text()) 
		+ "\n" + str("[color=#5DA271]Secondary Skill[/color]: [color=#ffd703]%s[/color]" % InputMap.get_action_list("secondary_skill")[0].as_text()) 
		+ "\n" + str("[color=#5DA271]Tertiary Skill[/color]: [color=#ffd703]%s[/color]" % InputMap.get_action_list("tertiary_skill")[0].as_text()) 
		+ "\n" + str("[color=#5DA271]Perk Skill[/color]: [color=#ffd703]%s[/color]" % InputMap.get_action_list("talent_skill")[0].as_text()) 
		+ "\n\n" + str(notes_dict["CombatPart2"]["Description2"] % InputMap.get_action_list("ui_cancel")[0].as_text())
		+ "\n\n" + notes_dict["CombatPart2"]["Description3"]
	)
	

func _on_CombatPart2_1_TextureButton_pressed():
	set_scrollcontainer_back_to_top()
	set_description_header_content(notes_dict["CombatPart2_1"]["Header"])
	set_description_textbox_content(
		str(notes_dict["CombatPart2_1"]["Description"] % InputMap.get_action_list("ui_dash")[0].as_text())
		+ "\n\n" + str(notes_dict["CombatPart2_1"]["Description2"] % InputMap.get_action_list("ui_attack")[0].as_text())
		+ "\n\n" + str(notes_dict["CombatPart2_1"]["Description3"] % str(Global.TEMPUS_TARDUS_CD))
	)

func _on_CombatPart3_TextureButton_pressed():
	set_scrollcontainer_back_to_top()
	set_description_header_content(notes_dict["CombatPart3"]["Header"])
	set_description_textbox_content(
		notes_dict["CombatPart3"]["Description"]
		+ "\n\n" + notes_dict["CombatPart3"]["Description2"]
	)
	


func _on_StatusEffects_TextureButton_pressed():
	set_scrollcontainer_back_to_top()
	set_description_header_content(notes_dict["StatusEffects"]["Header"])
	set_description_textbox_content(
		notes_dict["StatusEffects"]["Description"]
		+ "\n\n" + notes_dict["StatusEffects"]["Description2"]
		+ "\n\n" + notes_dict["StatusEffects"]["Description3"]
		+ "\n\n" + notes_dict["StatusEffects"]["Description4"]
	)


func _on_Debuffs_TextureButton_pressed():
	set_scrollcontainer_back_to_top()
	set_description_header_content(notes_dict["Debuffs"]["Header"])
	set_description_textbox_content(
		notes_dict["Debuffs"]["Description"]
		+ "\n\n" + notes_dict["Debuffs"]["Description2"]
		+ "\n\n" + notes_dict["Debuffs"]["Description3"]
	)


