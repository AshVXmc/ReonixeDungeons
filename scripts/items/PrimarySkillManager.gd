class_name PrimarySkillManager extends Control

enum skill_types {
	physical, fire, ice, earth
}
var selected_skill_type 

func _ready():
	visible = false


func _on_PrimaryCloseButton_pressed():
	print("closed primary skill ui")
	visible = false

