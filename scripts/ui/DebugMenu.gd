class_name DebugMenu extends Control
signal debugcmd(cmd)
var frametimes : Array = []
var FPS : float = 0

func _ready():
	self.visible = false
	connect("debugcmd", get_parent().get_parent().get_node("Player"), "debug_commands")
func _process(delta):
	if visible:
		Input.MOUSE_MODE_VISIBLE
	else:
		Input.MOUSE_MODE_HIDDEN
	if Input.is_action_just_pressed("ui_debug"):
		if !visible:
			visible = true
			emit_signal("debugcmd", "opened")
			$LineEdit.text = ""
			$Output.text = ""
		else:
			visible = false
			emit_signal("debugcmd", "closed")
	if Input.is_action_just_pressed("ui_accept"):
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
		"killall":
			emit_signal("debugcmd", "killall")
			$Output.text = "Killed all enemies"
		"fullhpots":
			emit_signal("debugcmd", "fullhpots")
			$Output.text = "Maxed out HPots"
		"fullmpots":
			emit_signal("debugcmd", "fullmpots")
			$Output.text = "Maxed out Mpots"
		"fullwine":
			emit_signal("debugcmd", "fullwine")
			$Output.text = "Maxed out Lwines"
		# Invulnerable to damage and abilities don't drain mana
		"godmode":
			Global.godmode = true if !Global.godmode else false
			$Output.text = "Godmode set to " + str(Global.godmode)
		_:
			$Output.text = "Invalid command"
