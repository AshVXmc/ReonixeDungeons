class_name DialogueScreen extends CanvasLayer

export(String, FILE, "*.json") var dialoguesfile
var dialogues = []
onready var talking = $Control/NinePatchRect/Talking
onready var dialogue = $Control/NinePatchRect/Dialogue

func _ready():
	$Control/NinePatchRect.visible = false
	dialogues = load_dialogues()

func load_dialogues():
	var file = File.new()
	if file.file_exists(dialoguesfile):
		file.open(dialoguesfile, file.READ)
		return parse_json(file.get_as_text())

func talk(talkerID : int):
	$Control/NinePatchRect.visible = true
	# ID system for NPCs
	match talkerID:
		0:
			if Input.is_action_just_pressed("ui_use"):
				talking.text = dialogues[1]["Talker"]
				dialogue.text = dialogues[1]["Dialogue"]
				
