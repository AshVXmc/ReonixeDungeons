class_name MonumentOfVictories extends GenericInteractable

onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
# Dependency
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var character_selection_ui : CanvasLayer = get_parent().get_node("DungeonEntrance/CharacterSelectionUI")
onready var character_menu_ui : CanvasLayer = get_parent().get_node("DungeonEntrance/CharacterMenuUI")
onready var stage_selection_ui : Control = $GoddessTrialsLevelSelectionUI/Control
onready var destination : String = get_parent().get_node("DungeonEntrance").destination
var is_opened : bool = false


# override 
func add_dialogue():
	var DIALOGUE = Dialogic.start(dialogic_timeline)
	DIALOGUE.connect("timeline_start", self, "start_of_dialogue")
	DIALOGUE.connect("dialogic_signal", self, "dialog_listener")
	DIALOGUE.connect("timeline_end",self , "end_of_dialogue")
	add_child(DIALOGUE)


func dialog_listener(string):
	if string == "accept_trials":
		start_ui()
		

func start_ui():
	character_selection_ui.layer = 5
	get_parent().get_node("DungeonEntrance").destination = "res://scenes/levels/GoddessTrialsLevel.tscn"
	stage_selection_ui.open_ui()
#	character_selection_ui.get_node("Control").initialize_ui()
	get_tree().paused = true

func close_ui():
	character_selection_ui.layer = 1
	get_tree().paused = false
