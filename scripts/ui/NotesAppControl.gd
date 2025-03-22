class_name NotesAppControl extends Control


var notes_dict : Dictionary
enum ACTIONS {
	ui_attack, ui_dash, left, right, ui_up, ui_down, jump,
	primary_skill, secondary_skill
}
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

func _on_TutorialMovement_TextureButton_pressed():
	
	var left_and_right : String = "Left: [color=#ffd703]%s[/color], Right: [color=#ffd703]%s[/color]" % [InputMap.get_action_list("left")[0].as_text(), InputMap.get_action_list("right")[0].as_text()]
	set_description_textbox_content(
		notes_dict["TutorialMovement"]["Description"]
		+ "\n" + left_and_right 
	)

