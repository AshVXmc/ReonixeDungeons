class_name Cellphone extends Control

var loaded_app_scene : Resource
var scene : Node
enum {
	NOTES
}
onready var player : Player = get_parent().get_parent().get_node("Player")

func _ready():
	$Control.visible = false



func _process(delta):
	if Input.is_action_just_pressed("ui_open_cellphone"):
		
		if weakref(scene).get_ref() != null:
			# when ui_open_cellphone is pressed when one of the apps
			# are open, close that app instead.
			if scene.name == "NotesApp" and scene.get_node("Control").visible:
				scene.get_node("Control").close_ui()
				$Control.visible = true
		else:
			open_ui() if !$Control.visible else close_ui()
		


func open_app(app : int):
	$Control.visible = false
	match app:
		NOTES:
			loaded_app_scene = load("res://scenes/menus/cellphone/NotesApp.tscn")
	scene = loaded_app_scene.instance()
	add_child(scene)
	scene.get_node("Control").initialize_ui()
	
func _on_CloseButton_pressed():
	close_ui()

func open_ui():
	$Control.visible = true
	get_tree().paused = true
	get_parent().layer = 5
	player.is_shopping = true

func close_ui():
	$Control.visible = false
	get_tree().paused = false
	get_parent().layer = 0
	player.is_shopping = false
func _on_App_Notes_pressed():
	open_app(NOTES)
