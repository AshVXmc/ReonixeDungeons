class_name GameOver extends Control

signal game_over()

onready var pause_ui = get_parent().get_parent().get_node("PauseUI")

func _ready():
	# Kills all enemies after game over to prevent unexpected bugs 
	connect("game_over", get_parent().get_parent().get_node("DebugMenu/Control"), "clear_enemies")
	visible = false

func open_game_over_ui():
	get_parent().layer = 7
	get_tree().paused = true
	visible = true

func _on_ReturnButton_pressed():
	var savefile : File = File.new()
	if savefile.file_exists(Global.savepath):
		var error = savefile.open(Global.savepath, File.READ)
		if error == OK:
			$LoadDataHelper.load_data(savefile)
			get_tree().change_scene(Global.levelpath)
	Global.alive = [true, true, true]
	get_tree().paused = false
	get_parent().layer = 1
	call_deferred('free')
	get_parent().get_parent().call_deferred('free')
	

func _on_ExitButton_pressed():
	Global.alive = [true, true, true]
	get_tree().paused = false
	get_parent().layer = 1
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
	call_deferred('free')

func restore_all_health():
	pass
	
func _on_GameOver_visibility_changed():
	emit_signal("game_over")



