class_name BeastiaryUI extends Control

var dict_beastiary : Dictionary
var goblin_icon = preload("res://assets/enemies/goblin1.png")
var bow_goblin_icon = preload("res://assets/enemies/bow_goblin1.png")
var bat_icon = preload("res://assets/enemies/bat_1.png")
var shaman_goblin_icon = preload("res://assets/enemies/goblin_shaman_1.png")
var slime_icon = preload("res://assets/enemies/slime1.png")
var fire_slime_icon = preload("res://assets/enemies/fire_slime_1.png")
var witch_goblin_icon = preload("res://assets/enemies/witch_goblin_summoning_1.png")

func _ready():
	close_ui()
	$NinePatchRect/ButtonsControl.visible = true
	$NinePatchRect/BeastInfoControl.visible = false
	# Uses a JSON file to load info
	var beastiaryinfo = File.new()
	beastiaryinfo.open("res://scenes/levels/hublevel/BeastiaryInfo.json", File.READ)
	dict_beastiary = parse_json(beastiaryinfo.get_as_text())

func initialize_ui():
	Global.can_open_pause_menu = false
	visible = true
	get_tree().paused = true

func close_ui():
	visible = false
	get_tree().paused = false
	Global.can_open_pause_menu = true

func _process(delta):
	if visible and Input.is_action_just_pressed("ui_cancel"):
		if $NinePatchRect/BeastInfoControl.visible:
			$NinePatchRect/BeastInfoControl.visible = false
			$NinePatchRect/ButtonsControl.visible = true
		else:
			close_ui()

func open_beast_info_screen(beast_name : String):
	$NinePatchRect/ButtonsControl.visible = false
	$NinePatchRect/BeastInfoControl/Name.text = dict_beastiary[beast_name]["Name"]
	$NinePatchRect/BeastInfoControl/Description.bbcode_text = dict_beastiary[beast_name]["Description"] + "[color=maroon][u][indent]" + dict_beastiary[beast_name]["Flavortext"] 
	match beast_name:
		"Goblin":
			$NinePatchRect/BeastInfoControl/Sprite.texture = goblin_icon
		"BowGoblin":
			$NinePatchRect/BeastInfoControl/Sprite.texture = bow_goblin_icon
		"Bat":
			$NinePatchRect/BeastInfoControl/Sprite.texture = bat_icon
		"ShamanGoblin":
			$NinePatchRect/BeastInfoControl/Sprite.texture = shaman_goblin_icon
		"WitchGoblin":
			$NinePatchRect/BeastInfoControl/Sprite.texture = witch_goblin_icon
		"Slime":
			$NinePatchRect/BeastInfoControl/Sprite.texture = slime_icon
		"FireSlime":
			$NinePatchRect/BeastInfoControl/Sprite.texture = fire_slime_icon
			
	$NinePatchRect/BeastInfoControl.visible = true
	
func _on_CloseButton_pressed():
	if $NinePatchRect/BeastInfoControl.visible:
		$NinePatchRect/BeastInfoControl.visible = false
		$NinePatchRect/ButtonsControl.visible = true
	else:
		close_ui()

func _on_ButtonGoblin_pressed():
	open_beast_info_screen("Goblin")

func _on_ButtonBowGoblin_pressed():
	open_beast_info_screen("BowGoblin")

func _on_ButtonBat_pressed():
	open_beast_info_screen("Bat")

func _on_ButtonShamanGoblin_pressed():
	open_beast_info_screen("ShamanGoblin")

func _on_ButtonSlime_pressed():
	open_beast_info_screen("Slime")

func _on_ButtonFireSlime_pressed():
	open_beast_info_screen("FireSlime")

func _on_ButtonWitchGoblin_pressed():
	open_beast_info_screen("WitchGoblin")
