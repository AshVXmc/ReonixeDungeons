class_name DebugMenu extends Control
signal debugcmd(cmd)
var numbers : String = "1234567891011121314151617181920"


func _ready():
	self.visible = false
	
	connect("debugcmd", get_parent().get_parent().get_node("Player"), "debug_commands")
func _process(delta):
#	if visible:
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if Input.is_action_just_pressed("ui_debug"):
		if !visible:
			visible = true
			emit_signal("debugcmd", "opened")
			$LineEdit.text = ""
			$Output.text = ""
		else:
			visible = false
			emit_signal("debugcmd", "closed")
	if visible:
		if Input.is_action_just_pressed("ui_select"):
			parse_command()
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
	

func parse_command():
	var command : String = $LineEdit.text
	match command.to_lower():
		"fullhealth":
			emit_signal("debugcmd", "fullhealth")
			$Output.text = "Restored health"
		"fullmana":
			emit_signal("debugcmd", "fullmana")
			$Output.text = "Restored mana"
		"fullopals":
			emit_signal("debugcmd", "fullopals")
			$Output.text = "Maxed out opals"
		"dash":
			Global.dash_unlocked = true if !Global.dash_unlocked else false
			$Output.text = "Dash set to " + str(Global.dash_unlocked)
		"glide":
			Global.glide_unlocked = true if !Global.glide_unlocked else false
			$Output.text = "Glide set to " + str(Global.glide_unlocked)
		"firesaw":
			Global.firesaw_unlocked = true if !Global.firesaw_unlocked else false
		# Gives the frozen effect
		"freeze":
			emit_signal("debugcmd", "freeze")
			$Output.text = "Freeze toggled"
		"killall":
			emit_signal("debugcmd", "killall")
			$Output.text = "Killed all enemies"
		"fullhpots":
			emit_signal("debugcmd", "fullhpots")
			$Output.text = "Maxed out HPots"
		"fullmpots":
			emit_signal("debugcmd", "fullmpots")
			$Output.text = "Maxed out Mpots"
		"fullwines":
			emit_signal("debugcmd", "fullwines")
			$Output.text = "Maxed out Lwines"
		"fullcrystals":
			emit_signal("debugcmd", "fullcrystals")
			$Output.text = "Maxed out Crystals"
		# Invulnerable to damage and knockback ,abilities don't drain mana
		"godmode":
			Global.godmode = true if !Global.godmode else false
			emit_signal("debugcmd", "fullhealth")
			emit_signal("debugcmd", "fullmana")
			$Output.text = "Entered Godmode" if Global.godmode else "Exited Godmode"
		"unlockall":
			Global.dash_unlocked = true
			Global.firesaw_unlocked = true
			Global.glide_unlocked = true
			$Output.text = "Abilities unlocked"
		"lockall":
			Global.dash_unlocked = false
			Global.firesaw_unlocked = false
			Global.glide_unlocked = false
			$Output.text = "Abilities locked"
		_:
			$Output.text = "Invalid command"
	
	# Teleport to a level
	if command.to_lower() in numbers:
		get_tree().change_scene("res://scenes/levels/Level" + command.to_lower() + ".tscn")


func _on_Control_visibility_changed():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
