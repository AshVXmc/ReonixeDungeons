class_name CharactersUI extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	visible = true
	update_ui()


func update_ui():
	$NinePatchRect/PlayerStatsLabel.bbcode_text = "[center]Max HP: " + str(Global.player_skill_multipliers["BaseHearts"] * 10) + "\n" + "Attack: " + str(Global.attack_power)


func _on_PlayerOpenTalentButton_pressed():
	get_parent().get_node("CharacterTalentsControl").visible = true


func _on_CloseButtonMainUI_pressed():
	pass
	# close the window
