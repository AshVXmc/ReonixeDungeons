class_name Level1 extends Level


func _ready():
	pass
#	trigger_dialogue("Level1_Intro")
	
func new_notification_received(force_to_read : bool, level : String, dialogue_timeline : String):
	$CellphoneUI/Cellphone/AnimationPlayer.play("NewNotification")


func trigger_dialogue(dialogue_timeline_name : String):
	var dialogue = Dialogic.start(dialogue_timeline_name)
	dialogue.pause_mode = Node.PAUSE_MODE_PROCESS
	# DIALOGIC INTERNAL UTILITY SIGNALS
	dialogue.connect("timeline_start", self, "start_of_dialogue")
	dialogue.connect("dialogic_signal", self, "dialog_listener")
	dialogue.connect("timeline_end", self, "end_of_dialogue")
	add_child(dialogue)

# automatically called at the start of a dialogue
func start_of_dialogue(timeline_name : String = ""):
	$Player.is_shopping = true
	get_tree().paused = true
	

# automatically called at the end of a dialogue
func end_of_dialogue(timeline_name : String = ""):
	$Player.is_shopping = false
	get_tree().paused = false
	$Player/CellphoneSprite.visible = false
	match timeline_name:
		"Level1_DontLeaveBeforeKillingEnemies":
			$Player.global_position.x = $DialogueTriggerAreas/Level1_Intro_Area2D.global_position.x
			$Player.global_position.y = $DialogueTriggerAreas/Level1_Intro_Area2D.global_position.y + 180
		"Level1_IceBlockedChest":
			pass
		
func _on_Level1_Intro_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		$Player.is_shopping = true
		$CellphoneUI/Cellphone/AnimationPlayer.play("NewNotification")
		var notif_anim_dur : float = $CellphoneUI/Cellphone/AnimationPlayer.current_animation_length
		yield(get_tree().create_timer(notif_anim_dur), "timeout")
		$Player.update_cellphone_position()
		$Player/CellphoneSprite.visible = true
		yield(get_tree().create_timer(1.0), "timeout")
		trigger_dialogue("Level1_Intro")
		$DialogueTriggerAreas/Level1_Intro_Area2D/CollisionShape2D.disabled = true


func _on_Level1_DontLeaveBeforeKillingEnemies_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		if get_tree().get_nodes_in_group("Level1_DefeatEnemiesBeforeProceeding").empty():
			$DialogueTriggerAreas/Level1_DontLeaveBeforeKillingEnemies_Area2D/CollisionShape2D.disabled = true
		else:
			$Player.is_shopping = true
			trigger_dialogue("Level1_DontLeaveBeforeKillingEnemies")

func _on_Level1_IceBlockedChest_area_entered(area):
	if area.is_in_group("Player"):
		$Player.is_shopping = true
		trigger_dialogue("Level1_IceBlockedChest")
		$DialogueTriggerAreas/Level1_IceBlockedChest/CollisionShape2D.disabled = true
		# for some reason this still triggers the dialogue even though its disabled.
		# delete the area node for now.
		$DialogueTriggerAreas/Level1_IceBlockedChest.call_deferred('free')
