class_name PlayerTutorialLevel extends Level

# OVERRIDE
func _ready():
	pass
#	start_dialogue("PlayerTutorial1")

func start_dialogue(dialogue_name : String, end_dialogue_function : String = ""):
	var BOOKSHELF_DIALOGUE = Dialogic.start(dialogue_name)
	if end_dialogue_function != "":
		BOOKSHELF_DIALOGUE.connect("timeline_end", self, end_dialogue_function)
	add_child(BOOKSHELF_DIALOGUE)
