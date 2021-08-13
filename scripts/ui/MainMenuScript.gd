extends MarginContainer

onready var start_selector = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/StartContainer/HBoxContainer/Arrow_Picker
onready var howtoplay_selector = $CenterContainer/VBoxContainer/CenterContainer3/VBoxContainer/Howtoplaycontainer/HBoxContainer/Arrow_Picker
onready var load_selector = $CenterContainer/VBoxContainer/CenterContainer6/VBoxContainer/LoadContainer/HBoxContainer/Arrow_Picker
onready var options_selector = $CenterContainer/VBoxContainer/CenterContainer4/VBoxContainer/Optionscontainer/HBoxContainer/Arrow_Picker
onready var exit_selector  = $CenterContainer/VBoxContainer/CenterContainer5/VBoxContainer/Exitcontainer/HBoxContainer/Arrow_Picker

var current_selection : int = 0

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_current_selection(0)

func handle_selection(_current_selection):
	match _current_selection:
		0:
			get_tree().change_scene("res://scenes/levels/Level1.tscn")	
			queue_free()
			Global.reset_player_data()
		1:
			# Load player data
			var savefile : File = File.new()
			if savefile.file_exists(Global.savepath):
				var error = savefile.open(Global.savepath, File.READ)
				if error == OK:
					var player_data : Dictionary = savefile.get_var()
					savefile.close()
					Global.max_hearts = player_data["MaxHealth"]
					Global.hearts = player_data["Health"]
					Global.max_mana = player_data["MaxMana"]
					Global.mana = player_data["Mana"]
					Global.healthpot_amount = player_data["Healthpot"]
					Global.dash_unlocked = player_data["DashUnlocked"]
					
					get_tree().change_scene("res://scenes/levels/" + player_data["Level"] + ".tscn")
				else:
					print("ERROR LOADING SAVE FILE")
		2:
			get_tree().change_scene("res://scenes/menus/HowToPlayMenu.tscn")
			queue_free()
		3:
			pass
		4:
			get_tree().quit()
		
func _process(delta):	
	if Input.is_action_just_pressed("ui_down") && current_selection < 4:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") && current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)	
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func set_current_selection(_current_selection):
	start_selector.text = ""
	load_selector.text = ""
	howtoplay_selector.text = ""
	options_selector.text = ""
	exit_selector.text = ""
	match _current_selection:
		0:
			start_selector.text = ">"
		1:
			load_selector.text = ">"	
		2:
			howtoplay_selector.text = ">"
		3:
			options_selector.text = ">"
		4:
			exit_selector.text = ">"
	
	
	
	


