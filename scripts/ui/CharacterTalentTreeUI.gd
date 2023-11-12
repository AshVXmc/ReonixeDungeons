class_name CharacterTalentTreeUI extends Control


func initialize_ui():
	visible = true
	update_talent_tree_ui()
	get_tree().paused = true
	
func update_talent_tree_ui():
	pass


func _on_CloseButtonMainUI_pressed():
	visible = false
	get_tree().paused = false


