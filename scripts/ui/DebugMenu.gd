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
		"freeze":
			emit_signal("debugcmd", "freeze")
			$Output.text = "Freeze toggled"
		"killall":
			emit_signal("debugcmd", "killall")
			$Output.text = "Killed all enemies"
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
			Global.fireburst_unlocked = true
			$Output.text = "Abilities unlocked"
		"lockall":
			Global.dash_unlocked = false
			Global.firesaw_unlocked = false
			Global.glide_unlocked = false
			Global.fireburst_unlocked = true
			$Output.text = "Abilities locked"
		"fillall":
			emit_signal("debugcmd", "fillall")
			$Output.text = "Filled all items"
		"opalall":
			emit_signal("debugcmd", "opalall")
			$Output.text = "Filled opals"
		"healall":
			emit_signal("debugcmd","healall")
			$Output.text = "Healed all stats"
		"bossall":
			Global.masked_goblin_defeated = true
			$Output.text = "Killed all bosses"
		"killcount":
			$Output.text = "Kill count: " + str(Global.enemies_killed)
		"returntohub":
			get_tree().change_scene("res://scenes/levels/HubLevel.tscn")
		_:
			$Output.text = "Invalid command"
	
	# Teleport to a level
	if command.to_lower() in numbers:
		get_tree().change_scene("res://scenes/levels/Level" + command.to_lower() + ".tscn")


func _on_Control_visibility_changed():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
