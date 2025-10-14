class_name PlayerTutorialLevel extends Level

const NUM_OF_LABELS : int = 4

# OVERRIDE
func _ready():
	var counter : int = 2
	while counter <= NUM_OF_LABELS:
		get_node("TutorialRichTextLabel" +  str(counter)).set_self_modulate(Color(1,1,1,0))
		counter += 1



func start_dialogue(dialogue_name : String, end_dialogue_function : String = ""):
	var BOOKSHELF_DIALOGUE = Dialogic.start(dialogue_name)
	if end_dialogue_function != "":
		BOOKSHELF_DIALOGUE.connect("timeline_end", self, end_dialogue_function)
	add_child(BOOKSHELF_DIALOGUE)

func make_label_appear(label_node : RichTextLabel):
	var animation : Animation = Animation.new()
	var anim_name : String = label_node.name + "_fade_anim"
	var property : String = label_node.name + ":self_modulate"
	var anim_length : float = 0.6
	
	$TutorialAnimationPlayer.add_animation(anim_name, animation)
	animation.length = anim_length
	var self_modulate_track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(self_modulate_track_index, property)
	animation.track_insert_key(self_modulate_track_index, 0, Color(1,1,1,0))
	animation.track_insert_key(self_modulate_track_index, anim_length, Color(1,1,1,1)) 
	animation.loop = false
	$TutorialAnimationPlayer.play(anim_name)


func _on_SpikesArea2D_1_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().after_damaged(false)
		area.get_parent().position = $SpikesTeleportPosition2D_1.global_position


func _on_Tutorial2TriggerArea2D_area_entered(area):
	if area.is_in_group("Player") and !$Tutorial2TriggerArea2D/CollisionShape2D.disabled:
		make_label_appear($TutorialRichTextLabel2)
		$Tutorial2TriggerArea2D/CollisionShape2D.disabled = true

func _on_Tutorial3TriggerArea2D_area_entered(area):
	if area.is_in_group("Player") and !$Tutorial3TriggerArea2D/CollisionShape2D.disabled:
		make_label_appear($TutorialRichTextLabel3)
		$Tutorial3TriggerArea2D/CollisionShape2D.disabled = true

func _on_Tutorial4TriggerArea2D_area_entered(area):
	if area.is_in_group("Player") and !$Tutorial4TriggerArea2D/CollisionShape2D.disabled:
		make_label_appear($TutorialRichTextLabel4)
		$Tutorial4TriggerArea2D/CollisionShape2D.disabled = true

func _on_Tutorial5TriggerArea2D_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().after_damaged(false)
		area.get_parent().position = $SpikesTeleportPosition2D_1.global_position

