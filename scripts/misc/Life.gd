extends Control

var heart_size : int = 96

func _ready():
	$HeartSlot.rect_size.x = Global.max_hearts * heart_size
	$Hearts.rect_size.x = Global.hearts * heart_size
	$HeartSlot2.rect_size.x = Global.character2_hearts * heart_size
	$Hearts2.rect_size.x = Global.character2_hearts * heart_size
	$HeartSlot3.rect_size.x = Global.character3_hearts * heart_size
	$Hearts3.rect_size.x = Global.character3_hearts * heart_size
func _process(delta):
	if Global.current_character == Global.equipped_characters[0]:
		$HeartSlot.visible = true
		$Hearts.visible = true
	else:
		$HeartSlot.visible = false
		$Hearts.visible = false

	if Global.current_character == Global.equipped_characters[1]:
		$HeartSlot2.visible = true
		$Hearts2.visible = true
	else:
		$HeartSlot2.visible = false
		$Hearts2.visible = false
	
	if Global.current_character == Global.equipped_characters[2]:
		$HeartSlot3.visible = true
		$Hearts3.visible = true
	else:
		$HeartSlot3.visible = false
		$Hearts3.visible = false
		
func on_player_life_changed(hearts : float, character : String):
	if character == Global.equipped_characters[0]:
		$Hearts.rect_size.x = hearts * heart_size
		print("char 1 hearts changed")
	elif character == Global.equipped_characters[1]:
		print("char 2 hearts changed")
		$Hearts2.rect_size.x = hearts * heart_size
	elif character == Global.equipped_characters[2]:
		$Hearts3.rect_size.x = hearts * heart_size
