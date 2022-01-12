extends Control

signal playerpos(ppos)
onready var gameover : Control = get_parent().get_node("GameOver")
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")

func _ready():
	connect("playerpos", Global, "player_position")
	self.visible = false
	gameover.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
#			notpaused = false
			visible = true
			
func _on_ResumeButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	visible = false


func _on_SaveButton_pressed():
	Global.save_player_data()
	emit_signal("playerpos",player.position)
	if !$Saved.visible:
		$Saved.visible = true
		yield(get_tree().create_timer(1.5), "timeout")
		$Saved.visible = false

func _on_QuitButton_pressed():
	if get_tree().paused:
		get_tree().paused = false
		get_tree().change_scene("res://scenes/menus/MainMenu.tscn")



