class_name BlackJackTable extends Node2D

onready var PLAYER : Area2D = get_parent().get_parent().get_node("Player").get_node("Area2D")

enum  {
	TINY = 50,
	SMALL = 100,
	MEDIUM = 250,
	LARGE = 500,
	MASSIVE = 1000
}

var current_bet : int = 0

func _ready():
	$BetOpalsUI/Control.visible = false
	$BetOpalsUI/Control/BetButtonTiny/Label.text = str(TINY)
	$BetOpalsUI/Control/BetButtonSmall/Label.text = str(SMALL)
	$BetOpalsUI/Control/BetButtonMedium/Label.text = str(MEDIUM)
	$BetOpalsUI/Control/BetButtonLarge/Label.text = str(LARGE)
	$BetOpalsUI/Control/BetButtonMassive/Label.text = str(MASSIVE)

func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
	else:
		$Label.visible = false
		$Keybind.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		get_tree().paused = true
		open_betting_ui()
#
#		$BlackJackUI/BlackJackControl.visible = true
#		$BlackJackUI.layer = 3
#		get_parent().get_parent().get_node("Player").is_shopping = true
		

func open_betting_ui():
	$BetOpalsUI/Control.visible = true
	$BetOpalsUI.layer = 5
	$BetOpalsUI/Control/CurrentOpalsLabel.bbcode_text = "[center]Opals: " + str(Global.opals_amount) + "[img= 40x40]res://assets/misc/opal.png[/img]"
	
func close_betting_ui():
	$BetOpalsUI/Control.visible = false
	$BetOpalsUI.layer = 1
# utility function for blackjack UI
func unstuck_player():
	get_parent().get_parent().get_node("Player").is_shopping = false
	



func _on_BetButtonTiny_pressed():
	if Global.opals_amount >= TINY:
		$BlackJackUI/BlackJackControl.start_new_round(TINY)
		close_betting_ui()
func _on_BetButtonSmall_pressed():
	if Global.opals_amount >= SMALL:
		$BlackJackUI/BlackJackControl.start_new_round(SMALL)
		close_betting_ui()
func _on_BetButtonMedium_pressed():
	if Global.opals_amount >= MEDIUM:
		$BlackJackUI/BlackJackControl.start_new_round(MEDIUM) 
		close_betting_ui()
func _on_BetButtonLarge_pressed():
	if Global.opals_amount >= LARGE:
		$BlackJackUI/BlackJackControl.start_new_round(LARGE) 
		close_betting_ui()
func _on_BetButtonMassive_pressed():
	if Global.opals_amount >= MASSIVE:
		$BlackJackUI/BlackJackControl.start_new_round(MASSIVE) 
		close_betting_ui()
