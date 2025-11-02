class_name OpalsGainedIndicatorParticle extends Node2D

# 1 digit = 40 x_pos
# 2 digits = 54 x_pos
# 3 digits = 68 x_pos
onready var opals_gained : int = 0
var SPEED : int = 200
var friction : int = 35
var direction_shift : Vector2 = Vector2()

func play_opals_gained_animation():
	$RichTextLabel/Opal.position.x = 40 + (14 * (len(str(opals_gained)) - 1))
	$RichTextLabel.bbcode_text = "+" + str(opals_gained)
	print("opal: " + $RichTextLabel.bbcode_text)
	$AnimationPlayer.play("opals_gained_indicator")
	direction_shift = Vector2(rand_range(-1,1), rand_range(-1,1))
	
func _process(delta):
	global_position += SPEED * direction_shift * delta
	SPEED = max(SPEED - friction * delta , 0)
