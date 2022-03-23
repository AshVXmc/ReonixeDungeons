extends CanvasLayer

export var Page : int 
const final_page : int = 5
const first_page : int = 1

func _ready():
	if Page == first_page:
		$Control/PrevButton.visible = false
	elif Page == final_page:
		$Control/NextButton.visible = false
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://scenes/menus/MainMenu.tscn")	
		queue_free()


func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")	
	queue_free()


func _on_NextButton_pressed():
	match Page:
		1:
			get_tree().change_scene("res://scenes/menus/HowToPlayMenu_2.tscn")
			queue_free()
		2:
			get_tree().change_scene("res://scenes/menus/HowToPlayMenu_3.tscn")
			queue_free()


func _on_PrevButton_pressed():
	match Page:
		1:
			pass
		2:
			get_tree().change_scene("res://scenes/menus/HowToPlayMenu.tscn")
			queue_free()
		3:
			get_tree().change_scene("res://scenes/menus/HowToPlayMenu_2.tscn")
			queue_free()
