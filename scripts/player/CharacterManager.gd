class_name CharacterManager extends Node2D

var GLACIELA : PackedScene = preload("res://scenes/characters/Glaciela.tscn")
var glaciela = GLACIELA.instance()
var AGNETTE : PackedScene = preload("res://scenes/characters/Agnette.tscn")
var agnette = AGNETTE.instance()
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
		
		glaciela = GLACIELA.instance()
		add_child(glaciela)
		if Global.current_character == "Glaciela":
			glaciela.visible = true
		else:
			glaciela.visible = false
	if Global.equipped_characters.has("Agnette") and character == "Agnette":
		agnette = AGNETTE.instance()
		add_child(agnette)
		if Global.current_character == "Agnette":
			agnette.visible = true
		else:
			agnette.visible = false
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

func swap_character(index_pressed : int):
	match index_pressed:
		1:
			Global.current_character = Global.equipped_characters[0]
			swap_in_character(Global.equipped_characters[0])
			swap_out_character(Global.equipped_characters[1])
			swap_out_character(Global.equipped_characters[2])
			print(Global.current_character)
			emit_signal("switch_in_signal", Global.equipped_characters[0])
		2:
			Global.current_character = Global.equipped_characters[1]
			swap_in_character(Global.equipped_characters[1])
			swap_out_character(Global.equipped_characters[0])
			swap_out_character(Global.equipped_characters[2])
			print(Global.current_character)
			emit_signal("switch_in_signal", Global.equipped_characters[1])
		3:
			Global.current_character = Global.equipped_characters[2]
			swap_in_character(Global.equipped_characters[2])
			swap_out_character(Global.equipped_characters[0])
			swap_out_character(Global.equipped_characters[1])
			print(Global.current_character)
			emit_signal("switch_in_signal", Global.equipped_characters[2])
func change_teammates():
	if $SwapCooldownTimer.is_stopped():
		if Input.is_action_just_pressed("slot_1") and Global.equipped_characters[0] != "":
			if Global.alive[0]:
				swap_character(1)
				$SwapCooldownTimer.start()
		elif Input.is_action_just_pressed("slot_2") and Global.equipped_characters[1] != "":
			if Global.alive[1]:
				swap_character(2)
				$SwapCooldownTimer.start()
		elif Input.is_action_just_pressed("slot_3") and Global.equipped_characters[2] != "":
			if Global.alive[2]:
				swap_character(3)
				$SwapCooldownTimer.start()
		
	
		
func swap_in_character(character):
	match character:
		"Glaciela":
			if glaciela:
				glaciela.visible = true
		"Agnette":
			if agnette:
				agnette.visible = true
func swap_out_character(character):
	match character:
		"Glaciela":
			if glaciela:
				glaciela.visible = false
		"Agnette":
			if agnette:
				agnette.visible = false



func _on_SwapCooldownTimer_timeout():
	pass # Replace with function body.
