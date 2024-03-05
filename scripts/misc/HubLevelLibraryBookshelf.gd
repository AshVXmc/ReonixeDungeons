class_name HubLevelBookOfShadowsBookshelf extends Area2D

onready var PLAYER = get_parent().get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	$Label.visible = false
	$Keybind.visible = false

func _process(delta):
	if self.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		player.is_shopping = true
		var BOOKSHELF_DIALOGUE = Dialogic.start("HubLevelBookOfShadowsBookshelf")
		BOOKSHELF_DIALOGUE.connect("timeline_end",self , "end_of_dialogue")
		add_child(BOOKSHELF_DIALOGUE)

func end_of_dialogue(timeline_name):
	unstuck_player()
	$Label.visible = true
	$Keybind.visible = true
func unstuck_player():
	player.is_shopping = false


func _on_BookshelfPlayerDetectorArea_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		$Keybind.visible = true


func _on_BookshelfPlayerDetectorArea_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false

