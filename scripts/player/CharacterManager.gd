class_name CharacterManager extends Node2D

var GLACIELA : PackedScene = preload("res://scenes/characters/Glaciela.tscn")
var glaciela = GLACIELA.instance()
var PLAYER : PackedScene
signal switch_in_signal(character)



func _ready():
	for a in Global.equipped_characters:
		update_party(a)
		connect_for_switch_in_signals(a)
		
func connect_for_switch_in_signals(charname : String):
	match charname:
		"Player":
			connect("switch_in_signal", get_parent(), "switched_in")


func update_party(character : String):
	if Global.equipped_characters.has("Glaciela") and character == "Glaciela":
		GLACIELA = load("res://scenes/characters/Glaciela.tscn")
		glaciela = GLACIELA.instance()
		add_child(glaciela)
		if Global.current_character == "Glaciela":
			glaciela.visible = true
		else:
			glaciela.visible = false
#	if Global.equipped_characters.has("Player") and character == "Player":
#		GLACIELA = load("res://scenes/characters/Glaciela.tscn")
#		glaciela = GLACIELA.instance()
#		add_child(glaciela)
#		if Global.current_character == "Glaciela":
#			glaciela.visible = true
#		else:
#			glaciela.visible = false
func _process(delta):
	change_teammates()

	
func change_teammates():
	if Input.is_action_just_pressed("slot_1") and Global.equipped_characters[0] != "":
		Global.current_character = Global.equipped_characters[0]
		swap_in_character(Global.equipped_characters[0])
		swap_out_character(Global.equipped_characters[1])
		swap_out_character(Global.equipped_characters[2])
		print(Global.current_character)
		emit_signal("switch_in_signal", Global.equipped_characters[0])
	elif Input.is_action_just_pressed("slot_2") and Global.equipped_characters[1] != "":
		Global.current_character = Global.equipped_characters[1]
		swap_in_character(Global.equipped_characters[1])
		swap_out_character(Global.equipped_characters[0])
		swap_out_character(Global.equipped_characters[2])
		print(Global.current_character)
		emit_signal("switch_in_signal", Global.equipped_characters[1])
		
	elif Input.is_action_just_pressed("slot_3") and Global.equipped_characters[2] != "":
		Global.current_character = Global.equipped_characters[2]
		swap_in_character(Global.equipped_characters[2])
		swap_out_character(Global.equipped_characters[0])
		swap_out_character(Global.equipped_characters[1])
		print(Global.current_character)
		emit_signal("switch_in_signal", Global.equipped_characters[2])
		
	
		
func swap_in_character(character):
	match character:
		"Glaciela":
			if glaciela:
				glaciela.visible = true

func swap_out_character(character):
	match character:
		"Glaciela":
			if glaciela:
				glaciela.visible = false



func _on_SwapCooldownTimer_timeout():
	pass # Replace with function body.
