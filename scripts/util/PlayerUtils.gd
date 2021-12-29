class_name PlayerUtils extends KinematicBody2D

func connect_signals() -> void: 
	# warning-ignore:return_value_discarded
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
# warning-ignore:return_value_discarded
	connect("mana_changed", get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", get_parent().get_node("LifeWineUI/LifeWineControl"), "on_player_lifewine_obtained")
	connect("manapot_obtained", get_parent().get_node("ManaPotUI/ManaPotControl"), "on_player_manapot_obtained")
	connect("opals_obtained", get_parent().get_node("OpalsUI/OpalsControl"), "on_player_opals_obtained")
	# HP singleton connect
# warning-ignore:return_value_discarded
	connect("life_changed", Global, "sync_hearts")
	emit_signal("life_changed", Global.hearts)
	# Mana singleton connect
# warning-ignore:return_value_discarded
	connect("mana_changed", Global, "sync_mana")
	emit_signal("mana_changed", Global.mana)
	# Healthpot inventory connect
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", Global, "sync_playerHealthpots")
	emit_signal("healthpot_obtained", Global.healthpot_amount)
	# Lifewine inventory connect
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", Global, "sync_playerLifeWines")
	emit_signal("lifewine_obtained", Global.lifewine_amount)
	
	connect("manapot_obtained", Global, "sync_playerManapots")
	emit_signal("manapot_obtained", Global.manapot_amount)
	
	connect("opals_obtained", Global, "sync_playerOpals")
	emit_signal("opals_obtained", Global.opals_amount)


