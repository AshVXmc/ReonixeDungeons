class_name BlackJack extends Control


const CARD : PackedScene = preload("res://scenes/minigames/Card.tscn")
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

func _ready():
	start_new_round()

func start_new_round():
	deck = INITIAL_DECK
	randomize()
	deck.shuffle()
#	for i in 2:
#		dealer_hand.append(deck.pop_back())
#		player_hand.append(deck.pop_back())
	
	
	dealer_hand.append([7, 'D'])
	dealer_hand.append([14, 'C'])
	
	player_hand.append([14, 'S'])
	player_hand.append([14, 'H'])

	
	
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


	update_scores()

func deal_card(card_owner : String, index : int, card_info : Array, face_down : bool = false):
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
	

func update_scores():
	var dealer_score : int = 0
	var player_score : int = 0
	
	var num_of_dealer_aces : int = 0
	var num_of_player_aces : int = 0
	
	for card in dealer_hand:
		# this if-statement turns the first card in the dealer's hand face-down.
		if !dealer_hand.find(card) == 0:
			if card[0] == Card.NUMBER.ACE:
				dealer_score += 11
				num_of_dealer_aces += 1
			elif card[0] == Card.NUMBER.JACK or card[0] == Card.NUMBER.QUEEN or card[0] == Card.NUMBER.KING:
				dealer_score += 10
			else:
				dealer_score += card[0]
	
	while num_of_dealer_aces > 0:
		if dealer_score > 21:
			dealer_score -= 10
		num_of_dealer_aces -= 1
	$DealerControl/DealerLabel.text = "Dealer: " + str(dealer_score)
	
	
	for card in player_hand:
		if card[0] == Card.NUMBER.ACE:
			player_score += 11
			num_of_player_aces += 1
		elif card[0] == Card.NUMBER.JACK or card[0] == Card.NUMBER.QUEEN or card[0] == Card.NUMBER.KING:
			player_score += 10
		else:
			player_score += card[0]
	
	while num_of_player_aces > 0:
		if player_score > 21:
			player_score -= 10
		num_of_player_aces -= 1
	$PlayerControl/PlayerLabel.text = "Player: " + str(player_score)
	
