extends CanvasLayer

signal transitioned
#func _ready():
#	layer = 0
#	$ColorRect.visible = false
func transition(mode : String = "FadeToBlack"):
	if mode == "FadeToBlack":
		$AnimationPlayer.play("FADE_TO_BLACK")
	elif mode == "FadeFromBlack":
		$ColorRect.visible = true
		layer = 5
		$AnimationPlayer.play("FADE")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FADE_TO_BLACK":
		emit_signal("transitioned")
		$AnimationPlayer.play("FADE")
	if anim_name == "FADE":
		pass
