class_name BeastiaryUI extends Control


func _ready():
	visible = false
	# Uses a JSON file to load info
	var beastiaryinfo = File.new()
	beastiaryinfo.open("res://scenes/levels/hublevel/BeastiaryInfo.json", File.READ)
	var dict_beastiary = parse_json(beastiaryinfo.get_as_text())
	print(dict_beastiary["Goblin"]["Name"])

func initialize_ui():
	visible = true
	get_tree().paused = true


func close_ui():
	visible = false
	get_tree().paused = false



