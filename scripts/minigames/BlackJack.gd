class_name BlackJack extends Control


const CARD : PackedScene = preload("res://scenes/minigames/Card.tscn")
onready var PLAYER : Player = get_parent().get_parent().get_parent().get_parent().get_node("Player")
const INITIAL_DECK : Array = [
	# 52 initial standard playing cards 
	# 2-10, J (11) , Q (12) , K (13) , A (14)
	# H (hearts), S (spades), C (clubs), D (diamonds)
	[2, 'H'], [3, 'H'], [4, 'H'], [5, 'H'], [6, 'H'], [7, 'H'], [8, 'H'], [9, 'H'], [10, 'H'], [11, 'H'], [12, 'H'], [13, 'H'], [14, 'H'],
	[2, 'S'], [3, 'S'], [4, 'S'], [5, 'S'], [6, 'S'], [7, 'S'], [8, 'S'], [9, 'S'], [10, 'S'], [11, 'S'], [12, 'S'], [13, 'S'], [14, 'S'],
	[2, 'C'], [3, 'C'], [4, 'C'], [5, 'C'], [6, 'C'], [7, 'C'], [8, 'C'], [9, 'C'], [10, 'C'], [11, 'C'], [12, 'C'], [13, 'C'], [14, 'C'],
	[2, 'D'], [3, 'D'], [4, 'D'], [5, 'D'], [6, 'D'], [7, 'D'], [8, 'D'], [9, 'D'], [10, 'D'], [11, 'D'], [12, 'D'], [13, 'D'], [14, 'D']
]
var deck : Array = INITIAL_DECK

# the amount of cards each side could have is limited to 5.
const MAX_CARDS : int = 5

var dealer_hand : Array 
var player_hand : Array
var first_dealer_card : Card

var dealer_score : int = 0
var player_score : int = 0
var num_of_dealer_aces : int = 0
var num_of_player_aces : int = 0
var is_standing : bool = false

var bet : int 
enum {
	DEALER_WINS, PLAYER_WINS, DRAW
}

#func _ready():
#	start_new_round()

func start_new_round(new_bet : int):
	visible = true
	get_parent().layer = 3
	get_parent().get_node("WinnerControl").visible = false
	bet = new_bet
	$BetAmountLabel.bbcode_text = "[color=#ffd703]Bet[/color]: " + str(new_bet) + "[img= 40x40]res://assets/misc/opal.png[/img]"
	deck = INITIAL_DECK
	player_score = 0
	dealer_score = 0
	player_hand.clear()
	dealer_hand.clear()
	num_of_dealer_aces = 0
	num_of_player_aces = 0
	first_dealer_card = null
	is_standing = false
	
	randomize()
	deck.shuffle()
	
	for child in $DealerControl.get_children():
		if child is Card:
			child.call_deferred('free')
	
	for child in $PlayerControl.get_children():
		if child is Card:
			child.call_deferred('free')
	for i in 2:
		dealer_hand.append(deck.pop_back())
		player_hand.append(deck.pop_back())



	var d : int = 1
	while d <= 2:
		if d == 1:
			deal_card("Dealer", d, dealer_hand[d - 1], true)
		else:
			deal_card("Dealer", d, dealer_hand[d - 1])
		d += 1
	
	var p : int = 1
	while p <= 2:
		deal_card("Player", p, player_hand[p - 1])
		p += 1

	for i in range(1, dealer_hand.size() + 1):
		if i != 1:
			update_dealer_score(i)
	for i in range(1, player_hand.size() + 1):
		update_player_score(i)

func deal_card(card_owner : String, index : int, card_info : Array, face_down : bool = false):
	# index starts at 1.
	var card : Card = CARD.instance()
	get_node(card_owner + "Control").add_child(card)
	card.name = "Card" + str(index)
	card.position = get_node(card_owner + "Control/Card" + str(index) + "Position2D").position
	
	
	card.number = card_info[0]
	card.suit = card_info[1]
	card.texture = card.texture.duplicate()
	if face_down:
		card.set_texture_to_face_down()
	else:
		card.set_card_texture(card_info[0], card_info[1])
	
	if card_owner == "Dealer" and index == 1:
		first_dealer_card = card



func update_dealer_score(card_index : int):
	var card_info = dealer_hand[card_index - 1]

	if card_info[0] == Card.NUMBER.ACE:
		dealer_score += 11
		num_of_dealer_aces += 1
	elif card_info[0] == Card.NUMBER.JACK or card_info[0] == Card.NUMBER.QUEEN or card_info[0] == Card.NUMBER.KING:
		dealer_score += 10
	else:
		dealer_score += card_info[0]

	while num_of_dealer_aces > 0:
		if dealer_score > 21:
			dealer_score -= 10
		num_of_dealer_aces -= 1
	$DealerControl/DealerLabel.text = "Dealer: " + str(dealer_score)
	

func update_player_score(card_index : int):
	var card_info = player_hand[card_index - 1]

	if card_info[0] == Card.NUMBER.ACE:
		player_score += 11
		num_of_player_aces += 1
	elif card_info[0] == Card.NUMBER.JACK or card_info[0] == Card.NUMBER.QUEEN or card_info[0] == Card.NUMBER.KING:
		player_score += 10
	else:
		player_score += card_info[0]

	while num_of_player_aces > 0:
		if player_score > 21:
			player_score -= 10
		num_of_player_aces -= 1
	$PlayerControl/PlayerLabel.text = "You: " + str(player_score)


func _on_HitButton_pressed():
	hit("Player")

func _on_StandButton_pressed():
	stand("Player")


func hit(hand_owner : String):
	if !is_standing and hand_owner == "Player" and player_hand.size() < MAX_CARDS and !deck.empty():
		var card : Array = deck.pop_back()
		player_hand.append(card)
		deal_card("Player", player_hand.size(), card)
		update_player_score(player_hand.size())
	
	if hand_owner == "Dealer":
		var card : Array = deck.pop_back()
		dealer_hand.append(card)
		deal_card("Dealer", dealer_hand.size(), card)
		update_dealer_score(dealer_hand.size())

func stand(hand_owner : String):
	
	if !is_standing and hand_owner == "Player":
		is_standing = true
		start_dealer_turn()
	elif hand_owner == "Dealer":
		print("Dealer stand")
#
func start_dealer_turn():
	yield(get_tree().create_timer(0.75), "timeout")
	first_dealer_card.set_card_texture(first_dealer_card.number, first_dealer_card.suit)
	update_dealer_score(1)
	
	# shitty dealer AI
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(14, 16)

	while dealer_score < num:
		yield(get_tree().create_timer(0.75), "timeout")
		hit("Dealer")
	stand("Dealer")
	
	
	yield(get_tree().create_timer(1), "timeout")
	end_current_round()


func determine_winner() -> int:
	if dealer_score == player_score:
		return DRAW
	if dealer_score == 21:
		return DEALER_WINS  
	if player_score == 21:
		return PLAYER_WINS
	
	if dealer_score > 21 and player_score <= 21:
		return PLAYER_WINS
	if player_score > 21 and dealer_score <= 21:
		return DEALER_WINS
	
	if dealer_score < 21 and player_score < 21:
		if dealer_score > player_score:
			return DEALER_WINS
		return PLAYER_WINS
	
	if dealer_score > 21 and player_score > 21:
		if dealer_score > player_score:
			return PLAYER_WINS
		return DEALER_WINS
	
	return -1

func end_current_round():
	var winner : String
	var s : String = ""
	if determine_winner() == DEALER_WINS:
		winner = "Dealer"
		s = "s"
		PLAYER.get_opals(-bet)
	elif determine_winner() == PLAYER_WINS:
		winner = "You"
		PLAYER.get_opals(bet)
	get_parent().get_node("WinnerControl/Header").bbcode_text = "[center]== [color=#ffd703]" + winner + " Win" + s + "[/color] =="
	get_parent().get_node("WinnerControl").visible = true
	
	
func _on_AgainButton_pressed():
	start_new_round(bet)
	get_parent().get_node("WinnerControl").visible = false


func _on_QuitButton_pressed():
	visible = false
	get_parent().get_node("WinnerControl").visible = false
	get_parent().layer = 1
	get_tree().paused = false
	get_parent().get_parent().unstuck_player()
