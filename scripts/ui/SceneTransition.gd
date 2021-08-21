extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("FADE_TO_BLACK")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FADE_TO_BLACK":
		emit_signal("transitioned")
		$AnimationPlayer.play("FADE")
	if anim_name == "FADE":
		print("Transition finished")
