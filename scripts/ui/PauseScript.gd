extends Control

signal playerpos(ppos)
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")

# HOW TO MAKE THE UI STILL RESPONSIVE EVEN WHEN PAUSED
# Go to the node's "Pause Mode" property, change to "Process"
func _ready():
	connect("playerpos", Global, "player_position")
	if Global.lighting:
		$Lighting.pressed = false
	else:
		$Lighting.pressed = true
	if Global.vsync:
		$Vsync.pressed = true
	else:
		$Vsync.pressed = false
	self.visible = false
	$SaveLabel.visible = false
	get_parent().get_node("PerfectDash").visible = false
func _notification(what):
	if !visible:
		if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
			
			get_tree().paused = false
			$Blur.visible = false
			get_parent().get_node("OutOfFocus").visible = false
		elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			
			$Blur.visible = true
			get_parent().get_node("OutOfFocus").visible = true
			get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and !get_parent().get_parent().get_node("Player").is_shopping:
		get_parent().layer += 1
		get_parent().get_parent().get_node("DebugMenu").get_node("Control").visible = false
		get_tree().paused = true
		visible = true
#		if visible:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		else:
#			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif Input.is_action_just_pressed("ui_debug"):
		get_tree().paused = false
		visible = false
		
func _on_ResumeButton_pressed():
	print("resumed game")
	get_tree().paused = false
	visible = false
	get_parent().layer = 1

func _on_SaveButton_pressed():
	if get_tree().get_current_scene().get_name() != "MaskedGoblinLevel":
		Global.levelpath = get_parent().get_parent().filename
		Global.player_position = player.position
		Global.is_loading_a_save = true
		Global.save_player_data()
	if !$SaveLabel.visible:
		if get_tree().get_current_scene().get_name() == "MaskedGoblinLevel":
			$SaveLabel.bbcode_text ="[color=red]Cannot save current progress.[/color]"
		else:
			$SaveLabel.bbcode_text ="			   [color=#2cfc03]Saved![/color]"
		$SaveLabel.visible = true
		yield(get_tree().create_timer(1.5), "timeout")
		$SaveLabel.visible = false


func _on_QuitButton_pressed():
	if get_tree().paused:
		get_tree().paused = false
		get_tree().change_scene("res://scenes/menus/MainMenu.tscn")


func _on_Lighting_toggled(button_pressed : bool):
	if get_parent().get_parent().get_node("Light2D").visible:
		get_parent().get_parent().get_node("Light2D").visible = false
		Global.lighting = false
		button_pressed = false
	else:
		get_parent().get_parent().get_node("Light2D").visible = true
		Global.lighting = true
		button_pressed = true
#	_on_SaveButton_pressed()


func _on_Vsync_toggled(button_pressed):
	if !OS.vsync_enabled:
		OS.vsync_enabled = true
		Global.vsync = true
		button_pressed = true
	else:
		OS.vsync_enabled = false
		Global.vsync = false
		button_pressed = false
#	_on_SaveButton_pressed()


func _on_MovesetsButton_pressed():
	visible = false
	get_parent().get_node("MovesetList").visible = true


