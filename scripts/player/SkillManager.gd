class_name PlayerSkillManager extends Node2D

signal mana_changed(amount)
var FIRE_PARTICLE : PackedScene = preload("res://scenes/particles/FlameParticle.tscn")
var FIREBALL : PackedScene = preload("res://scenes/skills/Fireball.tscn")
var FIRESAW : PackedScene = preload("res://scenes/skills/FireSaw.tscn")
var FIRE_FAIRY : PackedScene = preload("res://scenes/skills/FireFairy.tscn")
var BURNING_STATUS : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
var ICE_LANCE : PackedScene = preload("res://scenes/skills/IceLance.tscn")
var SUGAR_ROLL : PackedScene = preload("res://scenes/items/SugarRoll.tscn")
var WINTER_QUEEN : PackedScene = preload("res://scenes/skills/WinterQueen.tscn")
var SPIKE_TRAP : PackedScene = preload("res://scenes/skills/SpikeTrap.tscn")
var playeratkbonus : float
var glacielaatkbonus : float
onready var skills_ui  = get_parent().get_parent().get_node("SkillsUI/Control")


func _ready():
	connect("mana_changed", get_parent().get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")

func on_skill_used (
	skill_name : String, 
	attack_bonus : float = 0,
	# direction is only used on skills with directional paramaters like Fireball 
	direction = 1,
	# for icelance
	tundra_sigil_consumed = 0
	):
	match skill_name:
		###################
		## SKILLS #########
		###################
		"FireSaw":
			get_parent().is_using_primary_skill = true
			var firesaw : FireSaw = FIRESAW.instance()
			firesaw.atkbonus = attack_bonus
			var fireparticle = FIRE_PARTICLE.instance()
			get_parent().add_child(firesaw)
			get_parent().add_child(fireparticle)
			
			fireparticle.emitting = true
			fireparticle.one_shot = false
			if !Global.godmode:
				if Global.equipped_characters[0] == "Player" and Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
					Global.mana -= Global.player_skill_multipliers["FireSawCost"]
					emit_signal("mana_changed", Global.mana, "Player")
				elif Global.equipped_characters[1] == "Player" and Global.character2_mana >= Global.player_skill_multipliers["FireSawCost"]:
					Global.character2_mana -= Global.player_skill_multipliers["FireSawCost"]
					emit_signal("mana_changed", Global.character2_mana, "Player")
				elif Global.equipped_characters[2] == "Player" and Global.character3_mana >= Global.player_skill_multipliers["FireSawCost"]:
					Global.character3_mana -= Global.player_skill_multipliers["FireSawCost"]
					emit_signal("mana_changed", Global.character3_mana, "Player")
				
			get_parent().is_attacking = false
			get_parent().get_node("AttackCollision/CollisionShape2D").disabled = true

			# 8 is the duration of the firesaw
			yield(get_tree().create_timer(firesaw.get_node("DestroyedTimer").wait_time),"timeout")
			get_parent().is_using_primary_skill = false
			get_parent().remove_child(fireparticle)
		"FireFairy":
			get_parent().is_using_secondary_skill = true
			var fire_fairy = FIRE_FAIRY.instance()
		
			get_parent().get_parent().add_child(fire_fairy)
			fire_fairy.position = get_parent().global_position
			if !Global.godmode:
				if Global.equipped_characters[0] == "Player" and Global.mana >= Global.player_skill_multipliers["FireFairyCost"]:
					Global.mana -= Global.player_skill_multipliers["FireFairyCost"]
					emit_signal("mana_changed", Global.mana, "Player")
				elif Global.equipped_characters[1] == "Player" and Global.player_skill_multipliers["FireFairyCost"]:
					Global.character2_mana -= Global.player_skill_multipliers["FireFairyCost"]
					emit_signal("mana_changed", Global.character2_mana, "Player")
				elif Global.equipped_characters[2] == "Player" and Global.player_skill_multipliers["FireFairyCost"]:
					Global.character3_mana -= Global.player_skill_multipliers["FireFairyCost"]
					emit_signal("mana_changed", Global.character3_mana, "Player")
			yield(get_tree().create_timer(fire_fairy.get_node("DestroyedTimer").wait_time), "timeout")
			get_parent().is_using_secondary_skill = false
		"Fireball":
			var fireball = FIREBALL.instance()
			fireball.direction = direction
			get_parent().get_parent().add_child(fireball)
			fireball.position = global_position
		"CreateSugarRoll":
			var sugar_roll = SUGAR_ROLL.instance()
			get_parent().get_parent().add_child(sugar_roll)
			sugar_roll.position = global_position
		"ChaosMagic":
			var chaos_magic_ui = get_parent().get_node("ChaosMagicUI/Control")
			chaos_magic_ui.trigger_chaos_magic()
		"IceLance":
#			print("ICE LANCE")
			get_parent().is_using_secondary_skill = true
			var icelance = ICE_LANCE.instance()
			icelance.direction = direction
			icelance.tundra_sigil_atkbonus += (tundra_sigil_consumed * Global.glaciela_skill_multipliers["IceLanceDamageBonusPerTundraSigil"]) / 100
			get_parent().get_parent().add_child(icelance)
			icelance.position = global_position
			
			if !Global.godmode:
				if Global.equipped_characters[0] == "Glaciela" and Global.mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
					Global.mana -= Global.glaciela_skill_multipliers["IceLanceCost"]
					emit_signal("mana_changed", Global.mana, "Glaciela")
				elif Global.equipped_characters[1] == "Glaciela" and Global.character2_mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
					Global.character2_mana -= Global.glaciela_skill_multipliers["IceLanceCost"]
					emit_signal("mana_changed", Global.character2_mana, "Glaciela")
				elif Global.equipped_characters[2] == "Glaciela" and Global.character3_mana >= Global.glaciela_skill_multipliers["IceLanceCost"]:
					Global.character3_mana -= Global.glaciela_skill_multipliers["IceLanceCost"]
					emit_signal("mana_changed", Global.character3_mana, "Glaciela")
		"WinterQueen":
			var wq = WINTER_QUEEN.instance()
			get_parent().get_parent().add_child(wq)
			wq.position.x = global_position.x
			wq.position.y = global_position.y - 150
			if !Global.godmode:
				if Global.equipped_characters[0] == "Glaciela" and Global.mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					Global.mana -= Global.glaciela_skill_multipliers["WinterQueenCost"]
					emit_signal("mana_changed", Global.mana, "Glaciela")
				elif Global.equipped_characters[1] == "Glaciela" and Global.character2_mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					Global.character2_mana -= Global.glaciela_skill_multipliers["WinterQueenCost"]
					emit_signal("mana_changed", Global.character2_mana, "Glaciela")
				elif Global.equipped_characters[2] == "Glaciela" and Global.character3_mana >= Global.glaciela_skill_multipliers["WinterQueenCost"]:
					Global.character3_mana -= Global.glaciela_skill_multipliers["WinterQueenCost"]
					emit_signal("mana_changed", Global.character3_mana, "Glaciela")
		"ConeOfCold":
			# use direction. 1 = active, -1 = inactive
			var cone_of_cold = get_parent().get_parent().get_node("Player/CharacterManager/Glaciela/ConeOfCold")
			if direction == 1:
				cone_of_cold.activate_cone_of_cold()
				skills_ui.coneofcold_active = true
			elif direction == -1:
				cone_of_cold.deactivate_cone_of_cold()
				skills_ui.coneofcold_active = false
		"BearForm":
			get_parent().get_node("CharacterManager/Agnette").wild_shape(get_parent().get_node("CharacterManager/Agnette").forms.BEAR)
			get_parent().get_node("CharacterManager/Agnette/BearFormDurationTimer").start()
			if !Global.godmode:
				if Global.equipped_characters[0] == "Agnette" and Global.mana >= Global.agnette_skill_multipliers["BearFormCost"]:
					Global.mana -= Global.agnette_skill_multipliers["BearFormCost"]
					emit_signal("mana_changed", Global.mana, "Agnette")
				elif Global.equipped_characters[1] == "Agnette" and Global.character2_mana >= Global.agnette_skill_multipliers["BearFormCost"]:
					Global.character2_mana -= Global.agnette_skill_multipliers["BearFormCost"]
					emit_signal("mana_changed", Global.character2_mana, "Agnette")
				elif Global.equipped_characters[2] == "Agnette" and Global.character3_mana >= Global.agnette_skill_multipliers["BearFormCost"]:
					Global.character3_mana -= Global.agnette_skill_multipliers["BearFormCost"]
					emit_signal("mana_changed", Global.character3_mana, "Agnette")
		"RavenForm":
			get_parent().get_node("CharacterManager/Agnette").wild_shape(get_parent().get_node("CharacterManager/Agnette").forms.RAVEN)
			get_parent().get_node("CharacterManager/Agnette/RavenFormDurationTimer").start()
			if !Global.godmode:
				if Global.equipped_characters[0] == "Agnette" and Global.mana >= Global.agnette_skill_multipliers["RavenFormCost"]:
					Global.mana -= Global.agnette_skill_multipliers["RavenFormCost"]
					emit_signal("mana_changed", Global.mana, "Agnette")
				elif Global.equipped_characters[1] == "Agnette" and Global.character2_mana >= Global.agnette_skill_multipliers["RavenFormCost"]:
					Global.character2_mana -= Global.agnette_skill_multipliers["RavenFormCost"]
					emit_signal("mana_changed", Global.character2_mana, "Agnette")
				elif Global.equipped_characters[2] == "Agnette" and Global.character3_mana >= Global.agnette_skill_multipliers["RavenFormCost"]:
					Global.character3_mana -= Global.agnette_skill_multipliers["RavenFormCost"]
					emit_signal("mana_changed", Global.character3_mana, "Agnette")
		"SpikeGrowth":
			var trap = SPIKE_TRAP.instance()
			if get_tree().get_nodes_in_group("SpikeTrap").size() < Global.agnette_skill_multipliers["SpikeGrowthMaxCharges"]:
				trap.get_node("Area2D").add_to_group(str(Global.agnette_attack * (Global.agnette_skill_multipliers["SpikeGrowth"] / 100)))
				get_parent().get_parent().add_child(trap)
				if direction == 1:
					trap.position = Vector2(global_position.x + 120, global_position.y)
				elif direction == -1:
					trap.position = Vector2(global_position.x - 120, global_position.y)
