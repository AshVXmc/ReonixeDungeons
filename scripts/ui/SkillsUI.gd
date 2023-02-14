class_name SkillsUI extends Control

signal ability_on_cooldown(ability_name, attack_bonus)

var fireballcost : int = 2
const playericon = preload("res://assets/UI/player_character_icon.png")
const glacielaicon = preload("res://assets/UI/glaciela_character_icon.png")
const empty_icon = preload("res://assets/UI/empty_character_icon.png")
onready var character1 : String = Global.equipped_characters[0]
var can_swap_character : bool = true
onready var firesaw_ui = $PrimarySkill/Player/FireSaw/TextureProgress
const multiplier : int = 10


func _ready():
	update_character_ui()
	Global.current_character = character1
	print("Currently: " + Global.current_character)
	connect("ability_on_cooldown", get_parent().get_parent().get_node("Player"), "ability_on_entering_cooldown")
	update_skill_ui(Global.player_skills["PrimarySkill"], Global.player_skills["SecondarySkill"])
	$PrimarySkill/Player/FireSaw/TextureProgress.max_value = Global.player_skill_multipliers["FireSawCD"] * multiplier


func update_swap_character_status():
	can_swap_character = true if !can_swap_character else false
	if can_swap_character:
		$Characters/Character1.self_modulate = 1
		$Characters/Character2.self_modulate = 1
		$Characters/Character3.self_modulate = 1
	else:
		$Characters/Character1.self_modulate = 0.65
		$Characters/Character2.self_modulate = 0.65
		$Characters/Character3.self_modulate = 0.65
func flicker_icon(character):
	pass
func update_character_ui():
	match Global.equipped_characters[0]:
		"Player":
			$Characters/Character1.texture = playericon
		"Glaciela":
			$Characters/Character1.texture = glacielaicon
	match Global.equipped_characters[1]:
		"Player":
			$Characters/Character2.texture = playericon
		"Glaciela":
			$Characters/Character2.texture = glacielaicon
	match Global.equipped_characters[2]:
		"Player":
			$Characters/Character3.texture = playericon
		"Glaciela":
			$Characters/Character3.texture = glacielaicon


func update_skill_ui(primary : String, secondary : String):
	match primary:
		"FireSaw":
			$PrimarySkill/Player/FireSaw.visible = true
			$PrimarySkill/Player/FireSaw/CostLabel.text = str(Global.player_skill_multipliers["FireSawCost"])
	match secondary:
		"FireFairy":
			$SecondarySkill/Player/FireFairy.visible = true
			$SecondarySkill/Player/FireFairy/CostLabel.text = str(Global.player_skill_multipliers["FireFairyCost"])
func on_skill_used(skill_name : String):
	match skill_name:
		"FireSaw":
			toggle_firesaw()
		"FireFairy":
			toggle_fire_fairy()
		"PlayerChargedAttack":
			toggle_player_charged_attack()
func toggle_firesaw():
	print("firesaw cooldown start")
	emit_signal("ability_on_cooldown", "FireSaw")
	firesaw_ui.value = firesaw_ui.min_value

func toggle_fire_fairy():
	# 10 seconds is the duration of the fire fairy before expiring
	emit_signal("ability_on_cooldown", "FireFairy")
	$SecondarySkill/Player/FireFairy/FirefairyTimer.start(Global.player_skill_multipliers["FireFairyCD"])
	

func toggle_player_charged_attack():
	pass
func _process(delta):
	
	if Global.current_character == "Player":
		$PrimarySkill/Player.visible = true
		$SecondarySkill/Player.visible = true

		if firesaw_ui.value < firesaw_ui.max_value:
			$PrimarySkill/Player/FireSaw/Label.text = str(firesaw_ui.max_value - firesaw_ui.value)
			$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 0.65
		elif  firesaw_ui.value >= firesaw_ui.max_value:
			if Global.equipped_characters[0] == "Player":
				if Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
					$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 1.0
				else:
					$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 0.65
				$PrimarySkill/Player/FireSaw/Label.text = ""
			elif Global.equipped_characters[1] == "Player":
				if Global.character2_mana >= Global.player_skill_multipliers["FireSawCost"]:
					$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 1.0
				else:
					$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 0.65
				$PrimarySkill/Player/FireSaw/Label.text = ""
			elif Global.equipped_characters[2] == "Player":
				if Global.character3_mana >= Global.player_skill_multipliers["FireSawCost"]:
					$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 1.0
				else:
					$PrimarySkill/Player/FireSaw/TextureProgress.self_modulate.a = 0.65
				$PrimarySkill/Player/FireSaw/Label.text = ""
#		if Global.mana < firesawcost:
#			$PrimarySkill/Player/FireSaw/Sprite.self_modulate.a = 0.65
		
		if !$SecondarySkill/Player/FireFairy/FirefairyTimer.is_stopped():
			$SecondarySkill/Player/FireFairy/Label.text = str(round($SecondarySkill/Player/FireFairy/FirefairyTimer.time_left))
		elif $SecondarySkill/Player/FireFairy/FirefairyTimer.is_stopped():
			if Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
				$SecondarySkill/Player/FireFairy/Sprite.self_modulate.a = 1.0
			else:
				$SecondarySkill/Player/FireFairy/Sprite.self_modulate.a = 0.65
			$SecondarySkill/Player/FireFairy/Label.text = ""

	else:
		$PrimarySkill/Player.visible = false
		$SecondarySkill/Player.visible = false
	
	if Global.current_character == "Glaciela":
		$PrimarySkill/Glaciela.visible = true
		$SecondarySkill/Glaciela.visible = true
		if !$PrimarySkill/Glaciela/IceLance/IceLanceTimer.is_stopped():
			$PrimarySkill/Glaciela/IceLance/Label.text = str(round($PrimarySkill/Glaciela/IceLance/IceLanceTimer.time_left))
		elif $PrimarySkill/Glaciela/IceLance/IceLanceTimer.is_stopped():
			if Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
				$PrimarySkill/Glaciela/IceLance/Sprite.self_modulate.a = 1.0
			else:
				$PrimarySkill/Glaciela/IceLance/Sprite.self_modulate.a = 0.65
			$PrimarySkill/Glaciela/IceLance/Label.text = ""
		if Global.mana < Global.player_skill_multipliers["FireSawCost"]:
			$PrimarySkill/Glaciela/IceLance/Sprite.self_modulate.a = 0.65
	
		if !$SecondarySkill/Glaciela/IcebornIllusion/IcebornIllusionTimer.is_stopped():
			$SecondarySkill/Glaciela/IcebornIllusion/Label.text = str(round($SecondarySkill/Glaciela/IcebornIllusion/IcebornIllusionTimer.time_left))
		elif $SecondarySkill/Glaciela/IcebornIllusion/IcebornIllusionTimer.is_stopped():
			if Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
				$SecondarySkill/Glaciela/IcebornIllusion/Sprite.self_modulate.a = 1.0
			else:
				$SecondarySkill/Glaciela/IcebornIllusion/Sprite.self_modulate.a = 0.65
			$SecondarySkill/Glaciela/IcebornIllusion/Label.text = ""
		if Global.mana < Global.player_skill_multipliers["FireFairyCost"]:
			$SecondarySkill/Glaciela/IcebornIllusion/Sprite.self_modulate.a = 0.65
	
	
	else:
		$PrimarySkill/Glaciela.visible = false
		$SecondarySkill/Glaciela.visible = false





func _on_CooldownTickTimer_timeout():
	if Global.equipped_characters.has("Player"):
		firesaw_ui.value += 1 * multiplier
