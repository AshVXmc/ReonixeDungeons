class_name Level extends Node2D

signal equipped_skills()
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	connect("equipped_skills", $SkillsUI/Control, "update_skill_ui")
	emit_signal("equipped_skills")
	Global.save_player_data()
	# Disabling this feature, but keeping it here if needed.
#	if Global.is_loading_a_save:
#		get_node("Player").position = Global.player_position
#		Global.is_loading_a_save = false
#		print("reached")
#		Global.save_player_data()
	$ParallaxBackground/Background1.visible = true
	$GameOverUI/GameOver.visible = false
	if Global.lighting:
		$Light2D.visible = false
	else:
		$Light2D.visible = true
	if Global.vsync:
		OS.vsync_enabled = false
	else:
		OS.vsync_enabled = true
	if get_tree().get_current_scene().get_name() == "Level5" and !Global.activated_portals.has("Level5"):
		Global.activated_portals.append("Level5")
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
