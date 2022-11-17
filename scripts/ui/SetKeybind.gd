class_name SetKeybinds extends Control

var can_change_key : bool = false
var action_string # saves the name of the action

enum ACTIONS {
	ui_attack, ui_dash, left, right, ui_up, ui_down
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
#		else:
#			get_node(a + "/KeybindName").set_text("NONE")
func change_keybinds(new_key):
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
	InputMap.action_add_event(action_string, new_key)
	set_keybinds()
	
	
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
				yield(get_tree().create_timer(4.0), "timeout")
				$PressKeyNow/Label2.visible = false
				$PressKeyNow/NinePatchRect2.visible = false
func keybind_is_already_used(event_name):
	var used_keybinds : Array
	for a in ACTIONS:
		if !InputMap.get_action_list(a).empty():
		
#			var keybind_name = InputMap.get_action_list(a)[0].as_text()
			var keybind_names: Array =  InputMap.get_action_list(a)
			for k in keybind_names:
				used_keybinds.append(k.as_text())
	print(used_keybinds)
	if used_keybinds.has(event_name):
		return true
	else:
		return false
		
			
			
			
func mark_button(keybind_id : String):
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
	ui_attack.scancode = KEY_ENTER
	ui_dash.scancode = KEY_SHIFT
	left.scancode = KEY_A
	right.scancode = KEY_D
	ui_up.scancode = KEY_W
	ui_down.scancode = KEY_S 
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
