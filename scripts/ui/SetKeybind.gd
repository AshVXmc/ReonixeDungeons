class_name SetKeybinds extends Control

var can_change_key : bool = false
var action_string # saves the name of the action

enum ACTIONS {
	ui_attack, ui_dash, left, right, ui_up, ui_down, jump,
	primary_skill, secondary_skill
}

func _ready():
	$PressKeyNow.visible = false
#	print(InputMap.get_action_list("ui_attack")[0].as_text())
	set_keybinds()

func set_keybinds():
	for a in ACTIONS:
		get_node(a + "/ChangeKeybind").set_pressed(false)
		if !InputMap.get_action_list(a).empty():
			get_node(a + "/KeybindName").set_text(InputMap.get_action_list(a)[0].as_text())
			

	
func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
	call_deferred('free')

func _input(event):
	if event is InputEventKey:
		if can_change_key:
			keybind_is_already_used(event)
			if !keybind_is_already_used(event.as_text()):
				change_keybinds(event)
				can_change_key = false
				$PressKeyNow.visible = false
			else:
				print("Keybind is already used")
				
				$PressKeyNow/Label2.visible = true
				$PressKeyNow/NinePatchRect2.visible = true
				yield(get_tree().create_timer(1.0), "timeout")
				$PressKeyNow/Label2.visible = false
				$PressKeyNow/NinePatchRect2.visible = false
	
func find_control_with_keybind(keybind : InputEvent):
	for a in ACTIONS:
		for i in InputMap.get_action_list(a):
			if i == keybind:
				return a

func change_keybinds(new_key):
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
	InputMap.action_add_event(action_string, new_key)
	set_keybinds()


	
	
	
func keybind_is_already_used(event_name):
	var used_keybinds : Array
	for a in ACTIONS:
		if !InputMap.get_action_list(a).empty():
		
#			var keybind_name = InputMap.get_action_list(a)[0].as_text()
			var keybind_names: Array =  InputMap.get_action_list(a)
			for k in keybind_names:
				used_keybinds.append(k.as_text())
	if used_keybinds.has(event_name):
		return true
	else:
		return false

func mark_button(keybind_id : String):
	$PressKeyNow/Label3.bbcode_text = "[center]Rebinding '[color=#ffd703]" + keybind_id + "[/color]'[/center]"
	$PressKeyNow.visible = true
	can_change_key = true
	action_string = keybind_id
	for a in ACTIONS:
		if a != keybind_id:
			get_node(a + "/ChangeKeybind").set_pressed(false)




func reset_to_default_keybinds():
	var ui_attack = InputEventKey.new()
	var ui_dash = InputEventKey.new()
	var left = InputEventKey.new()
	var right = InputEventKey.new()
	var ui_up = InputEventKey.new()
	var ui_down = InputEventKey.new()
	var jump = InputEventKey.new()
	var primary_skill = InputEventKey.new()
	var secondary_skill = InputEventKey.new()
	# Default keybindings
	ui_attack.scancode = KEY_ENTER
	ui_dash.scancode = KEY_SHIFT
	left.scancode = KEY_A
	right.scancode = KEY_D
	ui_up.scancode = KEY_W
	ui_down.scancode = KEY_S
	jump.scancode = KEY_SPACE 
	primary_skill.scancode = KEY_Q
	secondary_skill.scancode = KEY_E
	InputMap.action_erase_event("ui_attack", InputMap.get_action_list("ui_attack")[0])
	InputMap.action_add_event("ui_attack", ui_attack)
	InputMap.action_erase_event("ui_dash", InputMap.get_action_list("ui_dash")[0])
	InputMap.action_add_event("ui_dash", ui_dash)
	InputMap.action_erase_event("left", InputMap.get_action_list("left")[0])
	InputMap.action_add_event("left", left)
	InputMap.action_erase_event("right", InputMap.get_action_list("right")[0])
	InputMap.action_add_event("right", right)
	InputMap.action_erase_event("ui_up", InputMap.get_action_list("ui_up")[0])
	InputMap.action_add_event("ui_up", ui_up)
	InputMap.action_erase_event("ui_down", InputMap.get_action_list("ui_down")[0])
	InputMap.action_add_event("ui_down", ui_down)
	InputMap.action_erase_event("jump", InputMap.get_action_list("jump")[0])
	InputMap.action_add_event("jump", jump)
	InputMap.action_erase_event("primary_skill", InputMap.get_action_list("primary_skill")[0])
	InputMap.action_add_event("primary_skill", primary_skill)
	set_keybinds()

func _on_Attack_ChangeKeybind_pressed():
	mark_button("ui_attack")
func _on_Dash_ChangeKeybind_pressed():
	mark_button("ui_dash")
func _on_Left_ChangeKeybind_pressed():
	mark_button("left")
func _on_Right_ChangeKeybind_pressed():
	mark_button("right")
func _on_Up_ChangeKeybind_pressed():
	mark_button("ui_up")
func _on_Down_ChangeKeybind_pressed():
	mark_button("ui_down")

func _on_ResetToDefault_pressed():
	reset_to_default_keybinds()


func _on_Cancel_pressed():
	can_change_key = false
	$PressKeyNow.visible = false





func _on_Jump_ChangeKeybind_pressed():
	mark_button("jump")


func _on_PrimarySkill_ChangeKeybind_pressed():
	mark_button("primary_skill")


func _on_SecondarySkill_ChangeKeybind_pressed():
	mark_button("secondary_skill")







#	if event is InputEventMouseButton and event.pressed:
#		match event.button_index:
#			BUTTON_LEFT:
#				mark_button("ui_attack")
#			BUTTON_RIGHT:
#				pass


