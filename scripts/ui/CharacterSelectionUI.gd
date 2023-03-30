class_name CharacterSelectionUI extends Control

# IMPORTANT NOTE
# Putting a control node over another control node and setting it to full rect will cause
# the parent control node to NOT respond to any input. 
const CHARACTER_LIST : Array = ["Player", "Glaciela", "Agnette" ,"" , "" , ""]
var equipped_characters : Array = ["", "", ""]
var picked_slot : int
# Only use this variable in the characteroptionslist ui. Reset to 0 after done.
const PLAYER_ICON = preload("res://assets/UI/player_character_icon.png")
const GLACIELA_ICON = preload("res://assets/UI/glaciela_character_icon.png")
const EMPTY_ICON = preload("res://assets/UI/empty_character_icon.png")
# FOR DEBUGGING PURPOSES
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print(equipped_characters)

func _ready():
	visible = false
	# Comment the initialize UI function when done.
#	initialize_ui()

func initialize_ui():
	visible = true
	get_tree().paused = true
	
func update_equipped_characters_ui():
	if equipped_characters.has("Player"):
		get_node("NinePatchRect/CharacterSlot" + str(equipped_characters.find("Player") + 1)).texture_normal = PLAYER_ICON
	if equipped_characters.has("Glaciela"):
		get_node("NinePatchRect/CharacterSlot" + str(equipped_characters.find("Glaciela") + 1)).texture_normal = GLACIELA_ICON


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
	yield(get_tree().create_timer(0.05), "timeout")
	visible = false
	get_tree().paused = false
	equipped_characters = Global.equipped_characters


func _on_CloseButtonCharacterOptionsListUI_pressed():
	button_modulate($CharacterOptionsList/CloseButtonCharacterOptionsListUI)
	yield(get_tree().create_timer(0.05), "timeout")
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
		equipped_characters.remove(picked_slot - 1)
		equipped_characters.insert(picked_slot - 1, "Player")
		$CharacterOptionsList.visible = false
	update_equipped_characters_ui()
	picked_slot = 0
	
	


func _on_CharacterGlaciela_pressed():
	if equipped_characters.has("Glaciela"):
		toggle_character_already_selected_label()
	else:
		button_modulate($CharacterOptionsList/CharacterGlaciela)
		yield(get_tree().create_timer(0.05), "timeout")
		equipped_characters.remove(picked_slot - 1)
		equipped_characters.insert(picked_slot - 1, "Glaciela")
		$CharacterOptionsList.visible = false
	update_equipped_characters_ui()
	picked_slot = 0
	

func _on_CharacterAgnette_pressed():
	pass


func _on_ClearSlot1_pressed():
	equipped_characters.remove(0)
	equipped_characters.insert(0, "")
	$NinePatchRect/CharacterSlot1.texture_normal = EMPTY_ICON
	update_equipped_characters_ui()
	
func _on_ClearSlot2_pressed():
	equipped_characters.remove(1)
	equipped_characters.insert(1, "")
	$NinePatchRect/CharacterSlot2.texture_normal = EMPTY_ICON
	update_equipped_characters_ui()

func _on_ClearSlot3_pressed():
	equipped_characters.remove(2)
	equipped_characters.insert(2, "")
	$NinePatchRect/CharacterSlot3.texture_normal = EMPTY_ICON
	update_equipped_characters_ui()
