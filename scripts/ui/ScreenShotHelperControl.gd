class_name ScreenShotHelperUI extends Control


func _process(delta):
	if Input.is_action_just_pressed("ui_screenshot"):
		var dir : Directory = Directory.new()
		if !dir.dir_exists("user://screenshots/"):
			# warning-ignore:return_value_discarded
			dir.make_dir_recursive("user://screenshots/")
		
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		var DATES = str(OS.get_datetime()["year"]) + "-" + str(OS.get_datetime()["month"]) + "-" +str(OS.get_datetime()["day"])
		var TIME = str(OS.get_datetime()["hour"]) + "-" + str(OS.get_datetime()["minute"]) + "-" + str(OS.get_datetime()["second"])
		image.save_png("user://screenshots/" + DATES + "_" + TIME + ".png")
		print("Captured!")

func toggle_captured_notification_ui():
	pass
