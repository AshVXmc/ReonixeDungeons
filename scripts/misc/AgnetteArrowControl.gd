class_name AgnetteArrowControl extends Control

var max_ammo : int = Global.agnette_max_ammo

func _ready():
	update_max_arrow_ammo_count(Global.agnette_max_ammo)
	update_arrow_ammo_ui(max_ammo)


# signal function, connected to agnette.
func update_arrow_ammo_ui(new_arrow_ammo_count : int):
	$RichTextLabel.bbcode_text = "%s/[color=#ffd703]%s[/color]" % [str(new_arrow_ammo_count), str(Global.agnette_max_ammo)]
	print("ammo changed")
# signal function, connected to agnette.
func update_max_arrow_ammo_count(new_max_arrow_ammo_count):
	max_ammo = new_max_arrow_ammo_count
