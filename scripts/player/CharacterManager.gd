class_name CharacterManager extends Node2D

var GLACIELA : PackedScene 
var glaciela


func _ready():
	if Global.equipped_characters.has("Glaciela"):
		GLACIELA = load("res://scenes/characters/Glaciela.tscn")
		glaciela = GLACIELA.instance()
		add_child(glaciela)
		glaciela.visible = false
		
func _process(delta):
	change_teammates()
	
	
func change_teammates():
	if $SwapCooldownTimer.is_stopped():
		if Input.is_action_just_pressed("slot_1"):
			Global.current_character = Global.equipped_characters[0]
			swap_in_character(Global.equipped_characters[0])
			swap_out_character(Global.equipped_characters[1])
			swap_out_character(Global.equipped_characters[2])
			$SwapCooldownTimer.start()
		elif Input.is_action_just_pressed("slot_2"):
			Global.current_character = Global.equipped_characters[1]
			swap_in_character(Global.equipped_characters[1])
			swap_out_character(Global.equipped_characters[0])
			swap_out_character(Global.equipped_characters[2])
			$SwapCooldownTimer.start()
		elif Input.is_action_just_pressed("slot_3"):
			Global.current_character = Global.equipped_characters[2]
			swap_in_character(Global.equipped_characters[2])
			swap_out_character(Global.equipped_characters[0])
			swap_out_character(Global.equipped_characters[1])
			$SwapCooldownTimer.start()			
		
func swap_in_character(character):
	match character:
		"Glaciela":
			glaciela.visible = true
func swap_out_character(character):
	match character:
		"Glaciela":
			glaciela.visible = false


func _on_SwapCooldownTimer_timeout():
	pass # Replace with function body.
