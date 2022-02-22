extends Control

signal playerpos(ppos)
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")


func _ready():
	connect("playerpos", Global, "player_position")
	if Global.lighting:
		$Lighting.pressed = false
	else:
		$Lighting.pressed = true
	self.visible = false
	$SaveLabel.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !get_tree().paused:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			visible = true
			
func _on_ResumeButton_pressed():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	visible = false


func _on_SaveButton_pressed():
	Global.save_player_data()
	emit_signal("playerpos",player.position)
	if !$SaveLabel.visible:
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


func _on_Vsync_toggled(button_pressed):
	if !OS.vsync_enabled:
		OS.vsync_enabled = true
		Global.vsync = true
		button_pressed = true
	else:
		OS.vsync_enabled = false
		Global.vsync = false
		button_pressed = false
	Global.vsync = true if !Global.vsync else false
