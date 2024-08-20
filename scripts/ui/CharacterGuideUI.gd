class_name CharacterGuideUI extends Control


var CHAPTERS : Array = ["Skills", "Damage Types", "Time Stop"]
onready var chapter1= $NinePatchRect/ChaptersBox/Chapter1/VBoxContainer/RichTextLabel

func _ready():
	var counter : int = 0
	for c in CHAPTERS:
		$NinePatchRect/ChapterSelectionOptionButton.add_item(c, counter)
		counter += 1
	
	chapter1.bbcode_text = chapter1.bbcode_text.replace("PKEY", "[color=#ffd073]" + InputMap.get_action_list("primary_skill")[0].as_text() + "[/color]")
	chapter1.bbcode_text = chapter1.bbcode_text.replace("SKEY", "[color=#ffd073]" + InputMap.get_action_list("secondary_skill")[0].as_text() + "[/color]")
	chapter1.bbcode_text = chapter1.bbcode_text.replace("TKEY", "[color=#ffd073]" + InputMap.get_action_list("tertiary_skill")[0].as_text() + "[/color]")
	chapter1.bbcode_text = chapter1.bbcode_text.replace("PRKEY", "[color=#ffd073]" + InputMap.get_action_list("talent_skill")[0].as_text() + "[/color]")
	
func update_ui():
	pass
