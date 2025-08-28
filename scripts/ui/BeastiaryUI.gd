class_name BeastiaryUI extends Control

var dict_beastiary : Dictionary
var goblin_icon : StreamTexture = preload("res://assets/enemies/goblin1.png")
var bow_goblin_icon : StreamTexture = preload("res://assets/enemies/bow_goblin1.png")
var bat_icon : StreamTexture = preload("res://assets/enemies/bat_1.png")
var shaman_goblin_icon : StreamTexture = preload("res://assets/enemies/goblin_shaman_1.png")
var slime_icon : StreamTexture = preload("res://assets/enemies/slime1.png")
#var fire_slime_icon : StreamTexture = preload("res://assets/enemies/fire_slime_1.png")
var witch_goblin_icon : StreamTexture = preload("res://assets/enemies/witch_goblin_summoning_1.png")
var spider_icon : StreamTexture = preload("res://assets/enemies/spider1.png")
var elder_spider_icon : StreamTexture = preload("res://assets/enemies/elder_spider1.png")


# in case i want to make a vbox the root node for scrolling (scalability baby)
onready var root_container : NinePatchRect = $NinePatchRect

func _ready():
	close_ui()
	root_container.get_node("ButtonsControl").visible = true
	root_container.get_node("BeastInfoControl").visible = false
	# Uses a JSON file to load info
	var beastiaryinfo = File.new()
	beastiaryinfo.open("res://scripts/jsondata/BeastiaryInfo.json", File.READ)
	dict_beastiary = parse_json(beastiaryinfo.get_as_text())

func initialize_ui():
	visible = true
	get_tree().paused = true
	get_parent().layer = 3
	Global.can_open_pause_menu = false
	update_beastiary_content()
	
func update_beastiary_content():
	for enemy in Global.enemies_encountered_data:
		if Global.enemies_encountered_data[enemy] > 0:
			get_node("NinePatchRect/ButtonsControl/Button" + str(enemy)).visible = true
 

func close_ui():
	visible = false
	get_tree().paused = false
	get_parent().layer = 1
	Global.can_open_pause_menu = true

func _process(delta):
	if visible and Input.is_action_just_pressed("ui_cancel"):
		if root_container.get_node("BeastInfoControl").visible:
			root_container.get_node("BeastInfoControl").visible = false
			root_container.get_node("BeastInfoControl").visible = true
		else:
			close_ui()

func open_beast_info_screen(beast_name : String):
	root_container.get_node("ButtonsControl").visible = false
	root_container.get_node("BeastInfoControl/Name").text = dict_beastiary[beast_name]["Name"]
	
	root_container.get_node("BeastInfoControl/Description").bbcode_text = dict_beastiary[beast_name]["Description"] + "\n\nYou have encountered and defeated this enemy " + str(Global.enemies_encountered[beast_name]) + " times." + "[color=maroon][u][indent]" + dict_beastiary[beast_name]["Flavortext"]
#	root_container.get_node("BeastInfoControl/Sprite").material = null
	match beast_name:
		"Goblin":
			root_container.get_node("BeastInfoControl/Sprite").texture = goblin_icon
		"BowGoblin":
			root_container.get_node("BeastInfoControl/Sprite").texture = bow_goblin_icon
		"Bat":
			root_container.get_node("BeastInfoControl/Sprite").texture = bat_icon
		"ShamanGoblin":
			root_container.get_node("BeastInfoControl/Sprite").texture = shaman_goblin_icon
		"WitchGoblin":
			root_container.get_node("BeastInfoControl/Sprite").texture = witch_goblin_icon
		"Slime":
			root_container.get_node("BeastInfoControl/Sprite").texture = slime_icon
		"FireSlime":
			root_container.get_node("BeastInfoControl/Sprite").texture = slime_icon # user paletteswapshader
			root_container.get_node("BeastInfoControl/Sprite").material = load("res://shaders/FireSlmeShader.tres")
		"Spider":
			root_container.get_node("BeastInfoControl/Sprite").texture = spider_icon
		"ElderSpider":
			root_container.get_node("BeastInfoControl/Sprite").texture = elder_spider_icon
	root_container.get_node("BeastInfoControl").visible = true
	
func _on_CloseButton_pressed():
	if root_container.get_node("BeastInfoControl").visible:
		root_container.get_node("BeastInfoControl").visible = false
		root_container.get_node("ButtonsControl").visible = true
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

func _on_ButtonSpider_pressed():
	open_beast_info_screen("Spider")

func _on_ButtonElderSpider_pressed():
	open_beast_info_screen("ElderSpider")
