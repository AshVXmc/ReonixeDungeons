extends Control

const TYPE : String = "ManaPot"
var size : int = 48

func _ready():
	$ManaSlot.rect_size.x = Global.max_mana * size
	$ManaIcon.rect_size.x = Global.mana * size
	$ManaSlot2.rect_size.x = Global.max_mana * size
	$ManaIcon2.rect_size.x = Global.character2_mana * size
	$ManaSlot3.rect_size.x = Global.max_mana * size
	$ManaIcon3.rect_size.x = Global.character3_mana * size
func _process(delta):
	if Global.current_character == Global.equipped_characters[0]:
		$ManaSlot.visible = true
		$ManaIcon.visible = true
	else:
		$ManaSlot.visible = false
		$ManaIcon.visible = false

	if Global.current_character == Global.equipped_characters[1]:
		$ManaSlot2.visible = true
		$ManaIcon2.visible = true
	else:
		$ManaSlot2.visible = false
		$ManaIcon2.visible = false
	
	if Global.current_character == Global.equipped_characters[2]:
		$ManaSlot3.visible = true
		$ManaIcon3.visible = true
	else:
		$ManaSlot3.visible = false
		$ManaIcon3.visible = false
		
func on_player_mana_changed(player_mana : float, character : String):
	if character == Global.equipped_characters[0]:
		$ManaIcon.rect_size.x = player_mana * size
	elif character == Global.equipped_characters[1]:
		$ManaIcon2.rect_size.x = player_mana * size
	elif character == Global.equipped_characters[2]:
		$ManaIcon3.rect_size.x = player_mana * size
	

	
