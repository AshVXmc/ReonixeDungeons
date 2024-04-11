class_name SkillsUI extends Control

signal ability_on_cooldown(ability_name, attack_bonus)

var fireballcost : int = 2
const playericon = preload("res://assets/UI/player_character_icon.png")
const glacielaicon = preload("res://assets/UI/glaciela_character_icon.png")
const agnetteicon = preload("res://assets/UI/agnette_character_icon.png")
const empty_icon = preload("res://assets/UI/empty_character_icon.png")
onready var character1 : String = Global.equipped_characters[0]
var can_swap_character : bool = true
onready var firesaw_ui = $PrimarySkill/Player/FireSaw/TextureProgress
onready var firefairy_ui = $SecondarySkill/Player/FireFairy/TextureProgress
onready var fireball_ui = $TertiarySkill/Player/Fireball/TextureProgress
onready var winterqueen_ui = $PrimarySkill/Glaciela/WinterQueen/TextureProgress
onready var icelance_ui = $SecondarySkill/Glaciela/IceLance/TextureProgress
onready var createsugarroll_ui = $TalentSkill/Player/CreateSugarRoll/TextureProgress
const multiplier : int = 10

func _ready():
	update_character_ui()
	if Global.player_talents["CreateSugarRoll"]["unlocked"]:
		$TalentSkill/Player/CreateSugarRoll.visible = true
#	update_maximum_endurance_ui()
	Global.current_character = character1
	print("Currently: " + Global.current_character)
	connect("ability_on_cooldown", get_parent().get_parent().get_node("Player"), "ability_on_entering_cooldown")
	update_skill_ui(Global.player_skills["PrimarySkill"], Global.player_skills["SecondarySkill"])
	update_skill_ui(Global.glaciela_skills["PrimarySkill"], Global.glaciela_skills["SecondarySkill"])
	firesaw_ui.max_value = Global.player_skill_multipliers["FireSawCD"] * multiplier
	firesaw_ui.value = firesaw_ui.max_value
	firefairy_ui.max_value = Global.player_skill_multipliers["FireFairyCD"] * multiplier
	firefairy_ui.value = firefairy_ui.max_value
	fireball_ui.max_value = Global.player_skill_multipliers["FireballCD"] * multiplier
	fireball_ui.value = fireball_ui.max_value
	winterqueen_ui.max_value = Global.glaciela_skill_multipliers["WinterQueenCD"] * multiplier
	winterqueen_ui.value = winterqueen_ui.max_value
	icelance_ui.max_value = Global.glaciela_skill_multipliers["IceLanceCD"] * multiplier
	icelance_ui.value = icelance_ui.max_value
	
	if Global.player_talents["CreateSugarRoll"]["unlocked"] and Global.player_talents["CreateSugarRoll"]["enabled"]:
		$TalentSkill/Player/CreateSugarRoll.visible = true
		createsugarroll_ui.max_value = Global.player_talents["CreateSugarRoll"]["cooldown"] * multiplier
		createsugarroll_ui.value = createsugarroll_ui.max_value
	else:
		$TalentSkill/Player/CreateSugarRoll.visible = false
#func update_maximum_endurance_ui():
#	$EnduranceMeter/TextureProgress.max_value = Global.max_endurance
func update_swap_character_status():
	can_swap_character = true if !can_swap_character else false
	if can_swap_character:
		$Characters/Slot1/Character1.self_modulate = 1
		$Characters/Slot2/Character2.self_modulate = 1
		$Characters/Slot3/Character3.self_modulate = 1
	else:
		$Characters/Slot1/Character1.self_modulate = 0.65
		$Characters/Slot2/Character2.self_modulate = 0.65
		$Characters/Slot3/Character3.self_modulate = 0.65
func flicker_icon(character):
	pass
func update_character_ui():
	match Global.equipped_characters[0]:
		"Player":
			$Characters/Slot1/Character1.texture = playericon
		"Glaciela":
			$Characters/Slot1/Character1.texture = glacielaicon
		"Agnette":
			$Characters/Slot1/Character1.texture = agnetteicon
	match Global.equipped_characters[1]:
		"Player":
			$Characters/Slot2/Character2.texture = playericon
		"Glaciela":
			$Characters/Slot2/Character2.texture = glacielaicon
		"Agnette":
			$Characters/Slot2/Character2.texture = agnetteicon
	match Global.equipped_characters[2]:
		"Player":
			$Characters/Slot3/Character3.texture = playericon
		"Glaciela":
			$Characters/Slot3/Character3.texture = glacielaicon
		"Agnette":
			$Characters/Slot3/Character3.texture = agnetteicon


func update_skill_ui(primary : String, secondary : String):
	match primary:
		"FireSaw":
			$PrimarySkill/Player/FireSaw.visible = true
			$PrimarySkill/Player/FireSaw/CostLabel.text = str(Global.player_skill_multipliers["FireSawCost"])
		"WinterQueen":
			$PrimarySkill/Glaciela/WinterQueen.visible = true
			$PrimarySkill/Glaciela/WinterQueen/CostLabel.text = str(Global.glaciela_skill_multipliers["WinterQueenCost"])
	match secondary:
		"FireFairy":
			$SecondarySkill/Player/FireFairy.visible = true
			$SecondarySkill/Player/FireFairy/CostLabel.text = str(Global.player_skill_multipliers["FireFairyCost"])
		"IceLance":
			$SecondarySkill/Glaciela/IceLance.visible = true
			$SecondarySkill/Glaciela/IceLance/CostLabel.text = str(Global.glaciela_skill_multipliers["IceLanceCost"])



func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			firesaw_ui.value = firesaw_ui.min_value
		"FireFairy":
			firefairy_ui.value = firefairy_ui.min_value
		"Fireball":
			if fireball_ui.value >= fireball_ui.max_value:
				fireball_ui.value = fireball_ui.min_value
		"CreateSugarRoll":
			createsugarroll_ui.value = createsugarroll_ui.min_value
		"IceLance":
			icelance_ui.value = icelance_ui.min_value
		"PlayerChargedAttack":
			pass


func _process(delta):
	
	if Global.current_character == "Player":
		$PrimarySkill/Player.visible = true
		$SecondarySkill/Player.visible = true
		$TertiarySkill/Player.visible = true
		##############
		# FIRE SAW ###
		##############
		if firesaw_ui.value < firesaw_ui.max_value:
			$PrimarySkill/Player/FireSaw/Label.text = str(stepify((firesaw_ui.max_value - firesaw_ui.value) / multiplier, 0.001))
			firesaw_ui.self_modulate.a = 0.65
		elif firesaw_ui.value >= firesaw_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				if Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
					firesaw_ui.self_modulate.a = 1.0
				else:
					firesaw_ui.self_modulate.a = 0.65
				$PrimarySkill/Player/FireSaw/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				if Global.character2_mana >= Global.player_skill_multipliers["FireSawCost"]:
					firesaw_ui.self_modulate.a = 1.0
				else:
					firesaw_ui.self_modulate.a = 0.65
				$PrimarySkill/Player/FireSaw/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				if Global.character3_mana >= Global.player_skill_multipliers["FireSawCost"]:
					firesaw_ui.self_modulate.a = 1.0
				else:
					firesaw_ui.self_modulate.a = 0.65
				$PrimarySkill/Player/FireSaw/Label.text = ""
		##############
		# FIRE FAIRY #
		##############
		if firefairy_ui.value < firefairy_ui.max_value:
			$SecondarySkill/Player/FireFairy/Label.text = str(stepify((firefairy_ui.max_value - firefairy_ui.value) / multiplier, 0.001))
			firefairy_ui.self_modulate.a = 0.65
		elif firefairy_ui.value >= firefairy_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				if Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
					firefairy_ui.self_modulate.a = 1.0
				else:
					firefairy_ui.self_modulate.a = 0.65
				$SecondarySkill/Player/FireFairy/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				if Global.character2_mana >= Global.player_skill_multipliers["FireFairyCost"]:
					firefairy_ui.self_modulate.a = 1.0
				else:
					firefairy_ui.self_modulate.a = 0.65
				$SecondarySkill/Player/FireFairy/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				if Global.character3_mana >= Global.player_skill_multipliers["FireFairyCost"]:
					firefairy_ui.self_modulate.a = 1.0
				else:
					firefairy_ui.self_modulate.a = 0.65
				$SecondarySkill/Player/FireFairy/Label.text = ""
		##############
		# FIREBALL #
		##############
		
		if fireball_ui.value < fireball_ui.max_value:
			$TertiarySkill/Player/Fireball/Label.text = str(stepify((fireball_ui.max_value - fireball_ui.value) / multiplier, 0.001))
			fireball_ui.self_modulate.a = 0.65
		elif fireball_ui.value >= fireball_ui.max_value:
			if Global.player_skill_multipliers["FireballCharges"] < Global.player_skill_multipliers["FireballMaxCharges"]:
				Global.player_skill_multipliers["FireballCharges"] += 1
				update_fireball_skill_ui(Global.player_skill_multipliers["FireballCharges"])
				if Global.player_skill_multipliers["FireballCharges"] < Global.player_skill_multipliers["FireballMaxCharges"]:
					fireball_ui.value = fireball_ui.min_value
			else:
				if Global.equipped_characters[0] == "Player":
					$TertiarySkill/Player/Fireball/Label.text = ""
				elif Global.equipped_characters[1] == "Player":
					$TertiarySkill/Player/Fireball/Label.text = ""
				elif Global.equipped_characters[2] == "Player":
					$TertiarySkill/Player/Fireball/Label.text = ""
		#####################
		# CREATE MANA ROLL ##
		#####################
		if createsugarroll_ui.value < createsugarroll_ui.max_value:
			$TalentSkill/Player/CreateSugarRoll/Label.text = str(stepify((createsugarroll_ui.max_value - createsugarroll_ui.value) / multiplier, 0.001))
			createsugarroll_ui.self_modulate.a = 0.65
		elif createsugarroll_ui.value >= createsugarroll_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				$TalentSkill/Player/CreateSugarRoll/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				$TalentSkill/Player/CreateSugarRoll/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				$TalentSkill/Player/CreateSugarRoll/Label.text = ""
	else:
		$PrimarySkill/Player.visible = false
		$SecondarySkill/Player.visible = false
		$TertiarySkill/Player.visible = false
		################
		# WINTER QUEEN #
		################
	if Global.current_character == "Glaciela":
		$PrimarySkill/Glaciela.visible = true
		$SecondarySkill/Glaciela.visible = true
		if winterqueen_ui.value < winterqueen_ui.max_value:
			$PrimarySkill/Glaciela/WinterQueen/Label.text = str(stepify((winterqueen_ui.max_value - winterqueen_ui.value) / multiplier, 0.001))
			winterqueen_ui.self_modulate.a = 0.65
		elif winterqueen_ui.value >= winterqueen_ui.max_value:
			if Global.equipped_characters[0] == "Glaciela":
				if Global.mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					winterqueen_ui.self_modulate.a = 1.0
				else:
					winterqueen_ui.self_modulate.a = 0.65
				$PrimarySkill/Glaciela/WinterQueen/Label.text = ""
			elif Global.equipped_characters[1] == "Glaciela":
				if Global.character2_mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					winterqueen_ui.self_modulate.a = 1.0
				else:
					winterqueen_ui.self_modulate.a = 0.65
				$PrimarySkill/Glaciela/WinterQueen/Label.text = ""
			elif Global.equipped_characters[2] == "Glaciela":
				if Global.character3_mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					winterqueen_ui.self_modulate.a = 1.0
				else:
					winterqueen_ui.self_modulate.a = 0.65
				$PrimarySkill/Glaciela/WinterQueen/Label.text = ""
		##############
		# ICE LANCE #
		##############
		if icelance_ui.value < icelance_ui.max_value:
			$SecondarySkill/Glaciela/IceLance/Label.text = str(stepify((icelance_ui.max_value - icelance_ui.value) / multiplier, 0.001))
			icelance_ui.self_modulate.a = 0.65
		elif icelance_ui.value >= icelance_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				if Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
					icelance_ui.self_modulate.a = 1.0
				else:
					icelance_ui.self_modulate.a = 0.65
				$SecondarySkill/Glaciela/IceLance/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				if Global.character2_mana >= Global.player_skill_multipliers["FireFairyCost"]:
					icelance_ui.self_modulate.a = 1.0
				else:
					icelance_ui.self_modulate.a = 0.65
				$SecondarySkill/Glaciela/IceLance/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				if Global.character3_mana >= Global.player_skill_multipliers["FireFairyCost"]:
					icelance_ui.self_modulate.a = 1.0
				else:
					icelance_ui.self_modulate.a = 0.65
				$SecondarySkill/Glaciela/IceLance/Label.text = ""

	
	
	else:
		$PrimarySkill/Glaciela.visible = false
		$SecondarySkill/Glaciela.visible = false



func reduce_skill_cooldown(character_name : String = "All", skill_type : String = "PrimarySkill", amount_in_seconds : float = 1.0):
	var amount : float = amount_in_seconds * multiplier
	match character_name:
		"All":
			firesaw_ui.value += amount
			firefairy_ui.value += amount
			winterqueen_ui.value += amount
			icelance_ui.value += amount
		"PrimariesOnly":
			firesaw_ui.value += amount
			winterqueen_ui.value += amount
		"SecondariesOnly":
			firefairy_ui.value += amount
			icelance_ui.value += amount
		"Player":
			if Global.equipped_characters.has("Player"):
				if skill_type == "PrimarySkill":
					firesaw_ui.value += amount
				elif skill_type == "SecondarySkill":
					firefairy_ui.value += amount
		"Glaciela":
			if Global.equipped_characters.has("Glaciela"):
				if skill_type == "PrimarySkill":
					winterqueen_ui.value += amount
				elif skill_type == "SecondarySkill":
					icelance_ui.value += amount

func _on_CooldownTickTimer_timeout():
	if Global.equipped_characters.has("Player"):
		firesaw_ui.value += 1 
		firefairy_ui.value += 1 
		fireball_ui.value += 1
		
		if Global.player_talents["CreateSugarRoll"]["unlocked"] and Global.player_talents["CreateSugarRoll"]["enabled"]:
			createsugarroll_ui.value += 1
	if Global.equipped_characters.has("Glaciela"):
		winterqueen_ui.value += 1 
		icelance_ui.value += 1 

#func reduce_endurance(amount : int):
#	$EnduranceMeter/TextureProgress.value -= amount

func update_fireball_skill_ui(charges : int):
	charges = clamp(charges, 0, Global.player_skill_multipliers["FireballCharges"])
	$TertiarySkill/Player/Fireball/ManaIcon.rect_size.x = charges * 16
func _on_EnduranceRegenTimer_timeout():
	$EnduranceMeter/TextureProgress.value += 2
