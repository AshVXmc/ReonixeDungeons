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
const AGNETTE_ICON = preload("res://assets/UI/agnette_character_icon.png")
const EMPTY_ICON = preload("res://assets/UI/empty_character_icon.png")
signal chosen_party_members(slot_one, slot_two, slot_three)
onready var charactermenu_ui = get_parent().get_parent().get_node("CharacterMenuUI/CharactersUI")
func _ready():
	visible = false
	$CharacterOptionsList.visible = false
	# Comment the initialize UI function when done.
#	initialize_ui()
	connect("chosen_party_members", get_parent().get_parent(), "load_next_scene")
	update_equipped_characters_ui()
# FOR DEBUGGING PURPOSES
#func _physics_process(delta):
#	if Input.is_action_just_pressed("ui_cancel"):
#		print(equipped_characters)

func initialize_ui():
	visible = true
	update_equipped_characters_ui()
	get_tree().paused = true


func update_equipped_characters_ui():
	if equipped_characters.has("Player"):
		get_node("NinePatchRect/CharacterSlot" + str(equipped_characters.find("Player") + 1)).texture_normal = PLAYER_ICON
	if equipped_characters.has("Glaciela"):
		get_node("NinePatchRect/CharacterSlot" + str(equipped_characters.find("Glaciela") + 1)).texture_normal = GLACIELA_ICON
	if equipped_characters.has("Agnette"):
		get_node("NinePatchRect/CharacterSlot" + str(equipped_characters.find("Agnette") + 1)).texture_normal = AGNETTE_ICON
		

func update_character_options_list_ui():
	if equipped_characters.has("Player"):
		$CharacterOptionsList/CharacterPlayer.self_modulate = Color(1,1,1, 0.4)
	else:
		$CharacterOptionsList/CharacterPlayer.self_modulate = Color(1,1,1,1)
	if equipped_characters.has("Glaciela"):
		$CharacterOptionsList/CharacterGlaciela.self_modulate = Color(1,1,1, 0.4)
	else:
		$CharacterOptionsList/CharacterGlaciela.self_modulate = Color(1,1,1,1)
	if equipped_characters.has("Agnette"):
		$CharacterOptionsList/CharacterAgnette.self_modulate = Color(1,1,1, 0.4)
	else:
		$CharacterOptionsList/CharacterAgnette.self_modulate = Color(1,1,1,1)
	
	
	
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

func pick_character(character : String):
	if equipped_characters.has(character):
		toggle_character_already_selected_label()
	else:
		button_modulate(get_node("CharacterOptionsList/Character" + character))
		yield(get_tree().create_timer(0.05), "timeout")
		equipped_characters.remove(picked_slot - 1)
		equipped_characters.insert(picked_slot - 1, character)
		$CharacterOptionsList.visible = false
	update_equipped_characters_ui()
	picked_slot = 0

func _on_CharacterPlayer_pressed():
	pick_character("Player")

func _on_CharacterGlaciela_pressed():
	pick_character("Glaciela")

func _on_CharacterAgnette_pressed():
	pick_character("Agnette")


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

func party_is_empty():
	if equipped_characters[0] == "" and  equipped_characters[1] == "" and equipped_characters[2] == "":
		return true
	else:
		return false

func _on_EnterLevelButton_pressed():
	if !party_is_empty():
		emit_signal("chosen_party_members", equipped_characters[0], equipped_characters[1], equipped_characters[2])
		visible = false
		get_tree().paused = false
	else:
		$NinePatchRect/PartyCannotBeEmptyLabel.visible = true
		yield(get_tree().create_timer(2.0), "timeout")
		$NinePatchRect/PartyCannotBeEmptyLabel.visible = false


func _on_LoadoutsButton_pressed():
	visible = false
	get_parent().layer = 1
	charactermenu_ui.toggle_ui()
