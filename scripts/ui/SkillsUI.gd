class_name SkillsUI extends Control


signal ability_on_cooldown(ability_name, attack_bonus)


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
onready var coneofcold_ui = $TertiarySkill/Glaciela/ConeOfCold/TextureProgress

onready var bearform_ui = $PrimarySkill/Agnette/BearForm/TextureProgress
onready var spikegrowth_ui = $TertiarySkill/Agnette/SpikeGrowth/TextureProgress

var coneofcold_active : bool = false

onready var createsugarroll_ui = $PerkSkill/Player/CreateSugarRoll/TextureProgress
onready var chaosmagic_ui = $PerkSkill/Player/ChaosMagic/TextureProgress
onready var CHAOS_MAGIC_UI : PackedScene = preload("res://scenes/menus/ChaosMagicUI.tscn") 
const multiplier : int = 10

func _ready():
#	update_maximum_endurance_ui()
	Global.current_character = character1
#	print("Currently: " + Global.current_character)
	connect("ability_on_cooldown", get_parent().get_parent().get_node("Player"), "ability_on_entering_cooldown")
	update_skill_ui(Global.player_skills["PrimarySkill"], Global.player_skills["SecondarySkill"], Global.player_skills["TertiarySkill"], Global.player_skills["PerkSkill"])
	update_skill_ui(Global.glaciela_skills["PrimarySkill"], Global.glaciela_skills["SecondarySkill"], Global.glaciela_skills["TertiarySkill"], Global.glaciela_skills["PerkSkill"])
	update_skill_ui(Global.agnette_skills["PrimarySkill"], Global.agnette_skills["SecondarySkill"], Global.agnette_skills["TertiarySkill"], Global.agnette_skills["PerkSkill"])
	
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
	coneofcold_ui.max_value = Global.glaciela_skill_multipliers["ConeOfColdCD"] * multiplier
	coneofcold_ui.value = coneofcold_ui.max_value
	
	bearform_ui.max_value = Global.agnette_skill_multipliers["BearFormCD"] * multiplier
	bearform_ui.value = bearform_ui.max_value
	spikegrowth_ui.max_value = Global.agnette_skill_multipliers["SpikeGrowthCD"] * multiplier
	spikegrowth_ui.value = spikegrowth_ui.max_value
	
	update_perk_skill_ui()
	update_character_ui()
#func update_maximum_endurance_ui():
#	$EnduranceMeter/TextureProgress.max_value = Global.max_endurance
func update_perk_skill_ui():
	if Global.player_skills["PerkSkill"] == "CreateSugarRoll":
		$PerkSkill/Player/CreateSugarRoll.visible = true
		createsugarroll_ui.max_value = Global.player_perks["CreateSugarRoll"]["cooldown"] * multiplier
		createsugarroll_ui.value = createsugarroll_ui.max_value
		$PerkSkill/Player/ChaosMagic.visible = false
	elif Global.player_skills["PerkSkill"] == "ChaosMagic":
		$PerkSkill/Player/ChaosMagic.visible = true
		chaosmagic_ui.max_value = Global.player_perks["ChaosMagic"]["cooldown"] * multiplier
		chaosmagic_ui.value = chaosmagic_ui.max_value
		$PerkSkill/Player/CreateSugarRoll.visible = false
	update_skill_ui(Global.player_skills["PrimarySkill"], Global.player_skills["SecondarySkill"], Global.player_skills["TertiarySkill"], Global.player_skills["PerkSkill"])
	update_skill_ui(Global.glaciela_skills["PrimarySkill"], Global.glaciela_skills["SecondarySkill"], Global.glaciela_skills["TertiarySkill"], Global.glaciela_skills["PerkSkill"])
	update_skill_ui(Global.agnette_skills["PrimarySkill"], Global.agnette_skills["SecondarySkill"], Global.agnette_skills["TertiarySkill"], Global.agnette_skills["PerkSkill"])

func update_swap_character_status():
	can_swap_character = true if !can_swap_character else false
	if can_swap_character:
		$Characters/Slot1/Character1.self_modulate = 1
		$Characters/Slot2/Character2.self_modulate = 1
		$Characters/Slot3/Character3.self_modulate = 1
	else:
		$Characters/Slot1/Character1.self_modulate = 0.4
		$Characters/Slot2/Character2.self_modulate = 0.4
		$Characters/Slot3/Character3.self_modulate = 0.4

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


func update_skill_ui(primary : String, secondary : String, tertiary : String, perk : String):
	match primary:
		"FireSaw":
			$PrimarySkill/Player/FireSaw.visible = true
			$PrimarySkill/Player/FireSaw/CostLabel.text = str(Global.player_skill_multipliers["FireSawCost"])
		"WinterQueen":
			$PrimarySkill/Glaciela/WinterQueen.visible = true
			$PrimarySkill/Glaciela/WinterQueen/CostLabel.text = str(Global.glaciela_skill_multipliers["WinterQueenCost"])
		"BearForm":
			$PrimarySkill/Agnette/BearForm.visible = true
			$PrimarySkill/Agnette/BearForm/CostLabel.text = str(Global.agnette_skill_multipliers["BearFormCost"])
	match secondary:
		"FireFairy":
			$SecondarySkill/Player/FireFairy.visible = true
			$SecondarySkill/Player/FireFairy/CostLabel.text = str(Global.player_skill_multipliers["FireFairyCost"])
		"IceLance":
			$SecondarySkill/Glaciela/IceLance.visible = true
			$SecondarySkill/Glaciela/IceLance/CostLabel.text = str(Global.glaciela_skill_multipliers["IceLanceCost"])
	match tertiary:
		"Fireball":
			$TertiarySkill/Player/Fireball.visible = true
		"ConeOfCold":
			$TertiarySkill/Glaciela/ConeOfCold.visible = true
		"SpikeGrowth":
			$TertiarySkill/Agnette/SpikeGrowth.visible = true
	match perk:
		"CreateSugarRoll":
			$PerkSkill/Player/CreateSugarRoll.visible = true
			$PerkSkill/Player/ChaosMagic.visible = false
		"ChaosMagic":
			$PerkSkill/Player/CreateSugarRoll.visible = false
			$PerkSkill/Player/ChaosMagic.visible = true
			


func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			firesaw_ui.value = firesaw_ui.min_value
		"FireFairy":
			firefairy_ui.value = firefairy_ui.min_value
		"Fireball":
			if fireball_ui.value >= fireball_ui.max_value:
				fireball_ui.value = fireball_ui.min_value
		
		"ConeOfCold":
			coneofcold_ui.value = coneofcold_ui.min_value
		"CreateSugarRoll":
			createsugarroll_ui.value = createsugarroll_ui.min_value
		"ChaosMagic":
			chaosmagic_ui.value = chaosmagic_ui.min_value
		"IceLance":
			icelance_ui.value = icelance_ui.min_value
		"WinterQueen":
			winterqueen_ui.value = winterqueen_ui.min_value
		"BearForm":
			bearform_ui.value = bearform_ui.min_value
		"SpikeGrowth":
			spikegrowth_ui.value = spikegrowth_ui.min_value


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
			firesaw_ui.self_modulate.a = 0.4
		elif firesaw_ui.value >= firesaw_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				if Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
					firesaw_ui.self_modulate.a = 1.0
				else:
					firesaw_ui.self_modulate.a = 0.4
				$PrimarySkill/Player/FireSaw/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				if Global.character2_mana >= Global.player_skill_multipliers["FireSawCost"]:
					firesaw_ui.self_modulate.a = 1.0
				else:
					firesaw_ui.self_modulate.a = 0.4
				$PrimarySkill/Player/FireSaw/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				if Global.character3_mana >= Global.player_skill_multipliers["FireSawCost"]:
					firesaw_ui.self_modulate.a = 1.0
				else:
					firesaw_ui.self_modulate.a = 0.4
				$PrimarySkill/Player/FireSaw/Label.text = ""
		##############
		# FIRE FAIRY #
		##############
		if firefairy_ui.value < firefairy_ui.max_value:
			$SecondarySkill/Player/FireFairy/Label.text = str(stepify((firefairy_ui.max_value - firefairy_ui.value) / multiplier, 0.001))
			firefairy_ui.self_modulate.a = 0.4
		elif firefairy_ui.value >= firefairy_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				if Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
					firefairy_ui.self_modulate.a = 1.0
				else:
					firefairy_ui.self_modulate.a = 0.4
				$SecondarySkill/Player/FireFairy/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				if Global.character2_mana >= Global.player_skill_multipliers["FireFairyCost"]:
					firefairy_ui.self_modulate.a = 1.0
				else:
					firefairy_ui.self_modulate.a = 0.4
				$SecondarySkill/Player/FireFairy/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				if Global.character3_mana >= Global.player_skill_multipliers["FireFairyCost"]:
					firefairy_ui.self_modulate.a = 1.0
				else:
					firefairy_ui.self_modulate.a = 0.4
				$SecondarySkill/Player/FireFairy/Label.text = ""
		##############
		## FIREBALL ##
		##############
		
		if fireball_ui.value < fireball_ui.max_value:
			$TertiarySkill/Player/Fireball/Label.text = str(stepify((fireball_ui.max_value - fireball_ui.value) / multiplier, 0.001))
			fireball_ui.self_modulate.a = 0.4
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
		#######################
		## CREATE SUGAR ROLL ##
		#######################
		if createsugarroll_ui.value < createsugarroll_ui.max_value:
			$PerkSkill/Player/CreateSugarRoll/Label.text = str(stepify((createsugarroll_ui.max_value - createsugarroll_ui.value) / multiplier, 0.001))
			createsugarroll_ui.self_modulate.a = 0.4
		elif createsugarroll_ui.value >= createsugarroll_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				$PerkSkill/Player/CreateSugarRoll/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				$PerkSkill/Player/CreateSugarRoll/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				$PerkSkill/Player/CreateSugarRoll/Label.text = ""
		###################
		### CHAOS MAGIC ###
		###################
		if chaosmagic_ui.value < chaosmagic_ui.max_value:
			$PerkSkill/Player/ChaosMagic/Label.text = str(stepify((chaosmagic_ui.max_value - chaosmagic_ui.value) / multiplier, 0.001))
			chaosmagic_ui.self_modulate.a = 0.4
		elif chaosmagic_ui.value >= chaosmagic_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				$PerkSkill/Player/ChaosMagic/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				$PerkSkill/Player/ChaosMagic/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				$PerkSkill/Player/ChaosMagic/Label.text = ""
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
		$TertiarySkill/Glaciela.visible = true
		if winterqueen_ui.value < winterqueen_ui.max_value:
			$PrimarySkill/Glaciela/WinterQueen/Label.text = str(stepify((winterqueen_ui.max_value - winterqueen_ui.value) / multiplier, 0.001))
			winterqueen_ui.self_modulate.a = 0.4
		elif winterqueen_ui.value >= winterqueen_ui.max_value:
			if Global.equipped_characters[0] == "Glaciela":
				if Global.mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					winterqueen_ui.self_modulate.a = 1.0
				else:
					winterqueen_ui.self_modulate.a = 0.4
				$PrimarySkill/Glaciela/WinterQueen/Label.text = ""
			elif Global.equipped_characters[1] == "Glaciela":
				if Global.character2_mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					winterqueen_ui.self_modulate.a = 1.0
				else:
					winterqueen_ui.self_modulate.a = 0.4
				$PrimarySkill/Glaciela/WinterQueen/Label.text = ""
			elif Global.equipped_characters[2] == "Glaciela":
				if Global.character3_mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					winterqueen_ui.self_modulate.a = 1.0
				else:
					winterqueen_ui.self_modulate.a = 0.4
				$PrimarySkill/Glaciela/WinterQueen/Label.text = ""
		##############
		# ICE LANCE #
		##############
		if icelance_ui.value < icelance_ui.max_value:
			$SecondarySkill/Glaciela/IceLance/Label.text = str(stepify((icelance_ui.max_value - icelance_ui.value) / multiplier, 0.001))
			icelance_ui.self_modulate.a = 0.4
		elif icelance_ui.value >= icelance_ui.max_value:
			if Global.equipped_characters[0] == "Glaciela":
				if Global.mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
					icelance_ui.self_modulate.a = 1.0
				else:
					icelance_ui.self_modulate.a = 0.4
				$SecondarySkill/Glaciela/IceLance/Label.text = ""
			elif Global.equipped_characters[1] == "Glaciela":
				if Global.character2_mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
					icelance_ui.self_modulate.a = 1.0
				else:
					icelance_ui.self_modulate.a = 0.4
				$SecondarySkill/Glaciela/IceLance/Label.text = ""
			elif Global.equipped_characters[2] == "Glaciela":
				if Global.character3_mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
					icelance_ui.self_modulate.a = 1.0
				else:
					icelance_ui.self_modulate.a = 0.4
				$SecondarySkill/Glaciela/IceLance/Label.text = ""
		################
		# CONE OF COLD #
		################
		if coneofcold_ui.value < coneofcold_ui.max_value:
			$TertiarySkill/Glaciela/ConeOfCold/Label.text = str(stepify((coneofcold_ui.max_value - coneofcold_ui.value) / multiplier, 0.001))
			coneofcold_ui.self_modulate.a = 0.4
		elif coneofcold_ui.value >= coneofcold_ui.max_value:
			if Global.equipped_characters[0] == "Glaciela":
				if Global.mana >= Global.glaciela_skill_multipliers["ConeOfColdCost"]:
					coneofcold_ui.self_modulate.a = 1.0
				else:
					coneofcold_ui.self_modulate.a = 0.4
				$TertiarySkill/Glaciela/ConeOfCold/Label.text = ""
			elif Global.equipped_characters[1] == "Glaciela":
				if Global.character2_mana >= Global.glaciela_skill_multipliers["ConeOfColdCost"]:
					coneofcold_ui.self_modulate.a = 1.0
				else:
					coneofcold_ui.self_modulate.a = 0.4
				$TertiarySkill/Glaciela/ConeOfCold/Label.text = ""
			elif Global.equipped_characters[2] == "Glaciela":
				if Global.character3_mana >= Global.glaciela_skill_multipliers["ConeOfColdCost"]:
					coneofcold_ui.self_modulate.a = 1.0
				else:
					coneofcold_ui.self_modulate.a = 0.4
				$TertiarySkill/Glaciela/ConeOfCold/Label.text = ""
	else:
		$PrimarySkill/Glaciela.visible = false
		$SecondarySkill/Glaciela.visible = false
		$TertiarySkill/Glaciela.visible = false
	
	if Global.current_character == "Agnette":
		$PrimarySkill/Agnette.visible = true
		$SecondarySkill/Agnette.visible = true
		$TertiarySkill/Agnette.visible = true
		if bearform_ui.value < bearform_ui.max_value:
			$PrimarySkill/Agnette/BearForm/Label.text = str(stepify((bearform_ui.max_value - bearform_ui.value) / multiplier, 0.001))
			bearform_ui.self_modulate.a = 0.4
		elif bearform_ui.value >= bearform_ui.max_value:
			if Global.equipped_characters[0] == "Agnette":
				if Global.mana >= Global.agnette_skill_multipliers["BearFormCost"]:
					bearform_ui.self_modulate.a = 1.0
				else:
					bearform_ui.self_modulate.a = 0.4
				$PrimarySkill/Agnette/BearForm/Label.text = ""
			elif Global.equipped_characters[1] == "Agnette":
				if Global.character2_mana >= Global.agnette_skill_multipliers["BearFormCost"]:
					bearform_ui.self_modulate.a = 1.0
				else:
					bearform_ui.self_modulate.a = 0.4
				$PrimarySkill/Agnette/BearForm/Label.text = ""
			elif Global.equipped_characters[2] == "Agnette":
				if Global.character3_mana >= Global.agnette_skill_multipliers["BearFormCost"]:
					bearform_ui.self_modulate.a = 1.0
				else:
					bearform_ui.self_modulate.a = 0.4
				$PrimarySkill/Agnette/BearForm/Label.text = ""
		##################
		## SPIKE GROWTH ##
		##################
		
		if spikegrowth_ui.value < spikegrowth_ui.max_value:
			$TertiarySkill/Agnette/SpikeGrowth/Label.text = str(stepify((spikegrowth_ui.max_value - spikegrowth_ui.value) / multiplier, 0.001))
			spikegrowth_ui.self_modulate.a = 0.4
		elif spikegrowth_ui.value >= spikegrowth_ui.max_value:
			if Global.agnette_skill_multipliers["SpikeGrowthCharges"] < Global.agnette_skill_multipliers["SpikeGrowthMaxCharges"]:
				Global.agnette_skill_multipliers["SpikeGrowthCharges"] += 1
				update_spikegrowth_skill_ui(Global.agnette_skill_multipliers["SpikeGrowthCharges"])
				if Global.agnette_skill_multipliers["SpikeGrowthCharges"] < Global.agnette_skill_multipliers["SpikeGrowthMaxCharges"]:
					spikegrowth_ui.value = spikegrowth_ui.min_value
			else:
				if Global.equipped_characters[0] == "Agnette":
					$TertiarySkill/Agnette/SpikeGrowth/Label.text = ""
				elif Global.equipped_characters[1] == "Agnette":
					$TertiarySkill/Agnette/SpikeGrowth/Label.text = ""
				elif Global.equipped_characters[2] == "Agnette":
					$TertiarySkill/Agnette/SpikeGrowth/Label.text = ""

	else:
		$PrimarySkill/Agnette.visible = false
		$SecondarySkill/Agnette.visible = false
		$TertiarySkill/Agnette.visible = false
	
	
	
	if !coneofcold_active:
		$TertiarySkill/Glaciela/ConeOfCold/ConeOfColdResource.value += Global.glaciela_skill_multipliers["ConeOfColdRegenRate"]
	
	

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
		
		if Global.player_perks["CreateSugarRoll"]["unlocked"] and Global.player_perks["CreateSugarRoll"]["enabled"]:
			createsugarroll_ui.value += 1
		if Global.player_perks["ChaosMagic"]["unlocked"] and Global.player_perks["ChaosMagic"]["enabled"]:
			chaosmagic_ui.value += 1
	if Global.equipped_characters.has("Glaciela"):
		winterqueen_ui.value += 1 
		icelance_ui.value += 1 
		coneofcold_ui.value += 1
	if Global.equipped_characters.has("Agnette"):
		bearform_ui.value += 1
		spikegrowth_ui.value += 1
#func reduce_endurance(amount : int):
#	$EnduranceMeter/TextureProgress.value -= amount

func update_fireball_skill_ui(charges : int):
	charges = clamp(charges, 0, Global.player_skill_multipliers["FireballCharges"])
	$TertiarySkill/Player/Fireball/ManaIcon.rect_size.x = charges * 16

func update_spikegrowth_skill_ui(charges : int):
	charges = clamp(charges, 0, Global.agnette_skill_multipliers["SpikeGrowthCharges"])
	$TertiarySkill/Agnette/SpikeGrowth/ManaIcon.rect_size.x = charges * 16
	print("SPIKE PLANTED")

func _on_EnduranceRegenTimer_timeout():
	$EnduranceMeter/TextureProgress.value += 2
	
func trigger_global_silence_ui(duration : float):
	$SilenceOverlay.visible = true
	yield(get_tree().create_timer(duration), "timeout")
	$SilenceOverlay.visible = false
