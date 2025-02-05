class_name Card extends Sprite

enum NUMBER {
	TWO = 2, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE
}
enum SUITS {
	HEARTS = 0, SPADES, CLUBS, DIAMONDS
}


export (NUMBER) var number
export (SUITS) var suit



func _ready():
	pass


func set_texture_to_face_down():
	texture.set_region(Rect2(0, 64, 12, 16))
	
func set_card_texture(number : int, suit : String):
	var suit_num : int = 0
	match suit:
		'H':
			suit_num = SUITS.HEARTS
		'S':
			suit_num = SUITS.SPADES
		'C':
			suit_num = SUITS.CLUBS
		'D':
			suit_num = SUITS.DIAMONDS
	texture.set_region(Rect2(12 * (number - 2), 16 * suit_num, 12, 16))





