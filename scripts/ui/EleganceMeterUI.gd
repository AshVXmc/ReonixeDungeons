class_name EleganceMeterUI extends Control

var elegance : int = 0
var rank : int
enum {
	C,B,A,S,SS,SSS
}
var is_attacking : bool
const MAX_ELEGANCE : int = 875
onready var c_tier = preload("res://assets/UI/elegance_c_tier.png")
onready var c_tier_background = preload("res://assets/UI/elegance_c_tier_background.png")
onready var b_tier = preload("res://assets/UI/elegance_b_tier.png")
onready var b_tier_background = preload("res://assets/UI/elegance_b_tier_background.png")
onready var a_tier = preload("res://assets/UI/elegance_a_tier.png")
onready var a_tier_background = preload("res://assets/UI/elegance_a_tier_background.png")
onready var s_tier = preload("res://assets/UI/elegance_s_tier.png")
onready var s_tier_background = preload("res://assets/UI/elegance_s_tier_background.png")
onready var ss_tier = preload("res://assets/UI/elegance_ss_tier.png")
onready var ss_tier_background = preload("res://assets/UI/elegance_ss_tier_background.png")
onready var sss_tier = preload("res://assets/UI/elegance_sss_tier.png")
onready var sss_tier_background = preload("res://assets/UI/elegance_sss_tier_background.png")

signal rank_and_combohitcount_info(rank, combohitcount)
func _ready():
	$DecayTimer.start()
	$EleganceGauge.texture_under = c_tier_background
	$EleganceGauge.texture_progress = c_tier
	rank = C
	elegance = 0
	$EleganceGauge.value = $EleganceGauge.min_value

# Relay information to the level script for level completion rewards


func elegance_changed(action_name):
	if action_name != null:
		is_attacking = true
		$AttackDecayTimer.start()
		match action_name:
			"BasicAttack":
				elegance += 10 
			"ChargedAttackLight":
				elegance += 20
			"ChargedAttackHeavy":
				elegance += 40
			"PrimarySkill":
				elegance += 120
			"SecondarySkill":
				elegance += 60
			"HitLight":
				elegance -= 70
			"HitHeavy":
				elegance -= 100
			_:
				if typeof(action_name) == TYPE_INT:
					elegance += action_name
				# Custom flat values for misc stuff
	
		$EleganceGauge.value = elegance
	if $EleganceGauge.value == $EleganceGauge.max_value:
		change_rank("Increase")
	

func change_rank(type : String):
	if type == "Increase":
		$EleganceGauge.value = $EleganceGauge.min_value
		elegance = 0
		rank = clamp(rank + 1, C, SSS)

		
		match rank:
			C:
				$EleganceGauge.max_value = 100
				$EleganceGauge.texture_under = c_tier_background
				$EleganceGauge.texture_progress = c_tier
			B:
				$EleganceGauge.max_value = 140
				$EleganceGauge.texture_under = b_tier_background
				$EleganceGauge.texture_progress = b_tier
			A:
				$EleganceGauge.max_value = 175
				$EleganceGauge.texture_under = a_tier_background
				$EleganceGauge.texture_progress = a_tier
			S:
				$EleganceGauge.max_value = 200
				$EleganceGauge.texture_under = s_tier_background
				$EleganceGauge.texture_progress = s_tier
			SS:
				$EleganceGauge.max_value = 300
				$EleganceGauge.texture_under = ss_tier_background
				$EleganceGauge.texture_progress = ss_tier
			SSS:
				$EleganceGauge.max_value = 400
				$EleganceGauge.texture_under = sss_tier_background
				$EleganceGauge.texture_progress = sss_tier
	if type == "Decrease":
		match rank:
			B:
				$EleganceGauge.max_value = 100
				$EleganceGauge.texture_under = c_tier_background
				$EleganceGauge.texture_progress = c_tier
				rank = C
			A:
				$EleganceGauge.max_value = 140
				$EleganceGauge.texture_under = b_tier_background
				$EleganceGauge.texture_progress = b_tier
				rank = B
			S:
				$EleganceGauge.max_value = 175
				$EleganceGauge.texture_under = a_tier_background
				$EleganceGauge.texture_progress = a_tier
				rank = A
			SS:
				$EleganceGauge.max_value = 200
				$EleganceGauge.texture_under = s_tier_background
				$EleganceGauge.texture_progress = s_tier
				rank = S
			SSS:
				$EleganceGauge.max_value = 300
				$EleganceGauge.texture_under = ss_tier_background
				$EleganceGauge.texture_progress = ss_tier
				rank = SS
		$EleganceGauge.value = $EleganceGauge.max_value
		elegance = $EleganceGauge.max_value
		$DecayTimer.start()

func _on_DecayTimer_timeout():
	if rank == C or B:
		$EleganceGauge.value -= 2.5
	elif rank == A or S:
		$EleganceGauge.value -= 5
	elif rank == SS or SSS:
		$EleganceGauge.value -= 7.5
		
	$DecayTimer.start()
	if $EleganceGauge.value == $EleganceGauge.min_value and !is_attacking:
		$DecayTimer.stop()
		change_rank("Decrease")
		print("RANK DECREASED")



func _on_AttackDecayTimer_timeout():
	is_attacking = false
