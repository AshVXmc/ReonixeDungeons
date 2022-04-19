class_name HubLevel extends Node2D

func _ready():
	$ColorRect.visible = true
	$ParallaxBackground/Background1.visible = true
	$GameOverUI/GameOver.visible = false
	if Global.lighting:
		$Light2D.visible = false
	else:
		$Light2D.visible = true
	if Global.vsync:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false

# warning-ignore:unused_argument
func _process(delta):
	# Screenshot
	if Input.is_action_just_pressed("ui_screenshot"):
		var dir : Directory = Directory.new()
		if !dir.dir_exists("user://screenshots/"):
			# warning-ignore:return_value_discarded
			dir.make_dir_recursive("user://screenshots/")
		print("Captured!")
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		var DATES = str(OS.get_datetime()["year"]) + "-" + str(OS.get_datetime()["month"]) + "-" +str(OS.get_datetime()["day"])
		var TIME = str(OS.get_datetime()["hour"]) + "-" + str(OS.get_datetime()["minute"]) + "-" + str(OS.get_datetime()["second"])
		image.save_png("user://screenshots/" + DATES + "_" + TIME + ".png")

