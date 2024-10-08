extends Control





func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
	call_deferred('free')

func _on_GodotLinkButton_pressed():
	OS.shell_open("https://godotengine.org/")

func _on_DialogicLinkButton_pressed():
	OS.shell_open("https://dialogic.pro/")

func _on_KritaLinkButton_pressed():
	OS.shell_open("https://krita.org/")


func _on_LicenseLinkButton_pressed():
	OS.shell_open("https://github.com/AshVXmc/ReonixeDungeons/blob/main/LICENSE")
