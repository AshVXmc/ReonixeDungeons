class_name DebugMenu extends Control
signal debugcmd(cmd)
signal update_ingr_ui(ingr_name, amount)
var numbers : String = "1234567891011121314151617181920"


func _ready():
	self.visible = false
	connect("update_ingr_ui", get_parent().get_parent().get_node("InventoryUI/Control"), "on_ingredient_obtained")
	connect("debugcmd", get_parent().get_parent().get_node("Player"), "debug_commands")
func _process(delta):
#	if visible:
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if Input.is_action_just_pressed("ui_debug"):
		if !visible:
			visible = true
			get_tree().paused = true
			emit_signal("debugcmd", "opened")
			$LineEdit.text = ""
			$Output.text = ""
		else:
			get_tree().paused = false
			visible = false
			emit_signal("debugcmd", "closed")
	if visible:
		if Input.is_action_just_pressed("ui_select"):
			parse_command()
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = false
			visible = false
			emit_signal("debugcmd", "closed")
	


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
			Global.fire_fairy_unlocked = true
			$Output.text = "Abilities unlocked"
		"lockall":
			Global.dash_unlocked = false
			Global.firesaw_unlocked = false
			Global.glide_unlocked = false
			$Output.text = "Abilities locked"
		"fillall":
			emit_signal("debugcmd", "fillall")
			$Output.text = "Filled all items"
		"fillingr":
			$Output.text = "Filled Ingredients"
			Global.common_monster_dust_amount = 99
			Global.goblin_scales_amount = 99
			emit_signal("update_ingr_ui", "common_dust", Global.common_monster_dust_amount)
			emit_signal("update_ingr_ui", "goblin_scales", Global.common_monster_dust_amount)
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
		"cyberninja":
			emit_signal("debugcmd", "cyberninja")
			$Output.text = "The dragon becomes me!"
		"defskin":
			emit_signal("debugcmd", "defskin")
			$Output.text = "Set to default skin"
		_:
			$Output.text = "Invalid command"
		
	
	# Teleport to a level
	if command.to_lower() in numbers:
		get_tree().change_scene("res://scenes/levels/Level" + command.to_lower() + ".tscn")


func _on_Control_visibility_changed():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
