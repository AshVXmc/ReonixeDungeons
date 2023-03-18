class_name CharacterSelectionUI extends Control

# IMPORTANT NOTE
# Putting a control node over another control node and setting it to full rect will cause
# the parent control node to NOT respond to any input. 
const CHARACTER_LIST : Array = ["Player", "Glaciela", "Agnette" ,"" , "" , ""]
var equipped_characters : Array = ["", "", ""]
var picked_slot : int
# Only use this variable in the characteroptionslist ui. Reset to 0 after done.


func _ready():
	visible = false
	# Comment the initialize UI function when done.
	initialize_ui()

func initialize_ui():
	visible = true
	get_tree().paused = true
	
	
func update_character_options_list_ui():
	if equipped_characters.has("Player"):
		$CharacterOptionsList/CharacterPlayer.self_modulate = Color(1,1,1, 0.4)
	else:
		$CharacterOptionsList/CharacterPlayer.self_modulate = Color(1,1,1,1)
	if equipped_characters.has("Glaciela"):
		$CharacterOptionsList/CharacterGlaciela.self_modulate = Color(1,1,1, 0.4)
	else:
		$CharacterOptionsList/CharacterGlaciela.self_modulate = Color(1,1,1,1)
	
func button_modulate(button_node : Node):
	button_node.self_modulate = Color(1,1,1,0.8)
	yield(get_tree().create_timer(0.2), "timeout")
	button_node.self_modulate = Color(1,1,1,1)
func toggle_character_already_selected_label():
	$CharacterOptionsList/AlreadySelected.visible = true
	yield(get_tree().create_timer(0.8), "timeout")
	$CharacterOptionsList/AlreadySelected.visible = false

func _on_CharacterSlot1_pressed():
	button_modulate($NinePatchRect/CharacterSlot1)
	open_character_options_list(1)
	
func _on_CharacterSlot2_pressed():
	button_modulate($NinePatchRect/CharacterSlot2)
	open_character_options_list(2)
	
func _on_CharacterSlot3_pressed():
	button_modulate($NinePatchRect/CharacterSlot3)
	open_character_options_list(3)
	
func _on_CloseButtonMainUI_pressed():
	button_modulate($NinePatchRect/CloseButtonMainUI)
	yield(get_tree().create_timer(0.1), "timeout")
	visible = false
	get_tree().paused = false
	equipped_characters = Global.equipped_characters


func _on_CloseButtonCharacterOptionsListUI_pressed():
	button_modulate($CharacterOptionsList/CloseButtonCharacterOptionsListUI)
	yield(get_tree().create_timer(0.15), "timeout")
	$CharacterOptionsList.visible = false
	


func open_character_options_list(slot : int):
	update_character_options_list_ui()
	$CharacterOptionsList.visible = true
	picked_slot = slot


func _on_CharacterPlayer_pressed():
	
	if equipped_characters.has("Player"):
		
		toggle_character_already_selected_label()
	else:
		button_modulate($CharacterOptionsList/CharacterPlayer)
		yield(get_tree().create_timer(0.05), "timeout")
		equipped_characters.insert(picked_slot - 1, "Player")
		$CharacterOptionsList.visible = false
	picked_slot = 0
	
	


func _on_CharacterGlaciela_pressed():
	
	if equipped_characters.has("Glaciela"):
		toggle_character_already_selected_label()
	else:
		button_modulate($CharacterOptionsList/CharacterGlaciela)
		yield(get_tree().create_timer(0.05), "timeout")
		equipped_characters.insert(picked_slot - 1, "Glaciela")
		$CharacterOptionsList.visible = false
	picked_slot = 0
	

func _on_CharacterAgnette_pressed():
	pass # Replace with function body.
