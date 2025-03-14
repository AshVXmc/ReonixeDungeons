class_name Cellphone extends Control


func _ready():
	$Control.visible = false

var loaded_app_scene : Resource
enum {
	NOTES
}

func _process(delta):
	if Input.is_action_just_pressed("ui_open_cellphone"):
		toggle_cellphone_ui()

func toggle_cellphone_ui():
	$Control.visible = true if !$Control.visible else false
	get_tree().paused = true if !get_tree().paused else false
	get_parent().layer = 5 if get_parent().layer == 0 else 0

func open_app(app : int):
	$Control.visible = false
	match app:
		NOTES:
			loaded_app_scene = load("res://scenes/menus/cellphone/NotesApp.tscn")
	var scene = loaded_app_scene.instance()
	add_child(scene)
	
func _on_CloseButton_pressed():
	toggle_cellphone_ui()

func _on_App_Notes_pressed():
	open_app(NOTES)
