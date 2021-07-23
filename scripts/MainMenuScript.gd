extends MarginContainer

onready var start_selector = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/StartContainer/HBoxContainer/Arrow_Picker
onready var howtoplay_selector = $CenterContainer/VBoxContainer/CenterContainer3/VBoxContainer/Howtoplaycontainer/HBoxContainer/Arrow_Picker
onready var options_selector = $CenterContainer/VBoxContainer/CenterContainer4/VBoxContainer/Optionscontainer/HBoxContainer/Arrow_Picker
onready var exit_selector  = $CenterContainer/VBoxContainer/CenterContainer5/VBoxContainer/Exitcontainer/HBoxContainer/Arrow_Picker

var current_selection : int = 0


func _ready():
	set_current_selection(0)

func handle_selection(_current_selection):
	match _current_selection:
		0:
			get_tree().change_scene("res://scenes/Level1.tscn")	
			queue_free()	
		1:
			get_tree().change_scene("res://scenes/menus/HowToPlayMenu.tscn")
			queue_free()
		2:
			print("To be added")
		3:
			get_tree().quit()			
		
func _process(delta):	
	if Input.is_action_just_pressed("ui_down") && current_selection < 3:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") && current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)	
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)				

func set_current_selection(_current_selection):
	start_selector.text = ""
	howtoplay_selector.text = ""
	options_selector.text = ""
	exit_selector.text = ""
	
	match _current_selection:
		0:
			start_selector.text = ">"
		1:
			howtoplay_selector.text = ">"
		2:
			options_selector.text = ">"
		3:
			exit_selector.text = ">"
	
	
	
	


