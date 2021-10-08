extends Control

signal player_position(posx, posy)
var notpaused : bool = true

func _ready():
	connect("player_position", Global, "get_player_position")
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if notpaused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			notpaused = false
			visible = true
			
func _on_ResumeButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	notpaused = true
	visible = false


func _on_SaveButton_pressed():
	Global.save_player_data()
	if !$Saved.visible:
		$Saved.visible = true
		yield(get_tree().create_timer(1.5), "timeout")
		$Saved.visible = false

func _on_QuitButton_pressed():
	if !notpaused:
		get_tree().paused = false
		get_tree().change_scene("res://scenes/menus/MainMenu.tscn")



