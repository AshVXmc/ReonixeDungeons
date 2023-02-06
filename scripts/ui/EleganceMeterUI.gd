class_name EleganceMeterUI extends Control

var elegance : int = 0
var hit_count : int = 0
const MAX_ATTACKS : int = 10
var rank : int
var rank_change_delay : bool = false
var attack_type_log : Array 
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
	reset_hitcount()
	rank = C
	Global.elegance_rank = "C"
	elegance = 0
	$EleganceGauge.value = $EleganceGauge.min_value

# Relay information to the level script for level completion rewards

func hitcount_changed(amount):
	$ComboHitCount.visible = true
	$ComboHitCountLabel.visible = true
	hit_count += amount 
	$ComboHitCount.text = str(hit_count)
	$HitCountResetTimer.stop()
	$HitCountResetTimer.start()
	
func reset_hitcount():
	hit_count = 0
	$ComboHitCount.text = str(hit_count)
	$ComboHitCount.visible = false
	$ComboHitCountLabel.visible = false
func log_attack(attack_type : String):
	# attack names change depending on characters, example: PlayerBA, GlacielaCAL, PlayerSlashFlurry
	if attack_type_log.size() == MAX_ATTACKS:
		attack_type_log.remove(MAX_ATTACKS - 1)
		
	attack_type_log.append(attack_type)
#	print(attack_type_log)
	
	
func elegance_changed(action_name):
	if action_name != null:
		hit_count += 1
		is_attacking = true
		$AttackDecayTimer.start()
		match action_name:
			"BasicAttack":
				elegance += 25
				log_attack("BA")
			"ChargedAttackLight":
				elegance += 35
				log_attack("CAL")
			"ChargedAttackHeavy":
				elegance += 50
			"PrimarySkill":
				elegance += 120
			"SecondarySkill":
				elegance += 60
			"PerfectDash":
				elegance += 80
				change_rank("Increase")
			"Hit":
				if rank == C:
					elegance = 0
					$EleganceGauge.value = $EleganceGauge.min_value
				else:
					change_rank("Decrease", true)
					# Empty gauge after taking a hit

			_:
				if typeof(action_name) == TYPE_INT:
					elegance += action_name
				# Custom flat values for misc stuff
#		if !$RankDownTimer.is_stopped():
#			$RankDownTimer.stop()
		$EleganceGauge.value = elegance
		
	if $EleganceGauge.value == $EleganceGauge.max_value:
		change_rank("Increase")
		
		$RankDownDelayTimer.start()
	

func change_rank(type : String, after_getting_hit : bool = false):
	if type == "Increase":
		$EleganceGauge.value = $EleganceGauge.min_value
		elegance = 0
		rank = clamp(rank + 1, C, SSS)

		
		match rank:
			C:
				$EleganceGauge.max_value = 150
				$EleganceGauge.texture_under = c_tier_background
				$EleganceGauge.texture_progress = c_tier
				Global.elegance_rank = "C"
			B:
				$EleganceGauge.max_value = 200
				$EleganceGauge.texture_under = b_tier_background
				$EleganceGauge.texture_progress = b_tier
				Global.elegance_rank = "B"
			A:
				$EleganceGauge.max_value = 300
				$EleganceGauge.texture_under = a_tier_background
				$EleganceGauge.texture_progress = a_tier
				Global.elegance_rank = "A"
			S:
				$EleganceGauge.max_value = 400
				$EleganceGauge.texture_under = s_tier_background
				$EleganceGauge.texture_progress = s_tier
				Global.elegance_rank = "S"
			SS:
				$EleganceGauge.max_value = 450
				$EleganceGauge.texture_under = ss_tier_background
				$EleganceGauge.texture_progress = ss_tier
				Global.elegance_rank = "SS"
			SSS:
				$EleganceGauge.max_value = 500
				$EleganceGauge.texture_under = sss_tier_background
				$EleganceGauge.texture_progress = sss_tier
				Global.elegance_rank = "SSS"
		$RankIconAnimationPlayer.play("RankUp")
	if type == "Decrease":
		match rank:
			B:
				$EleganceGauge.max_value = 200
				$EleganceGauge.texture_under = c_tier_background
				$EleganceGauge.texture_progress = c_tier
				rank = C
				Global.elegance_rank = "C"

			
			A:
				$EleganceGauge.max_value = 300
				$EleganceGauge.texture_under = b_tier_background
				$EleganceGauge.texture_progress = b_tier
				rank = B
				Global.elegance_rank = "B"
			S:
				$EleganceGauge.max_value = 400
				$EleganceGauge.texture_under = a_tier_background
				$EleganceGauge.texture_progress = a_tier
				rank = A
				Global.elegance_rank = "A"
				
			SS:
				$EleganceGauge.max_value = 450
				$EleganceGauge.texture_under = s_tier_background
				$EleganceGauge.texture_progress = s_tier
				rank = S
				Global.elegance_rank = "S"
				
			SSS:
				$EleganceGauge.max_value = 500
				$EleganceGauge.texture_under = ss_tier_background
				$EleganceGauge.texture_progress = ss_tier
				rank = SS
				Global.elegance_rank = "SS"
		if !after_getting_hit:
			$EleganceGauge.value = $EleganceGauge.max_value
			elegance = $EleganceGauge.max_value
		else:
			$EleganceGauge.value = $EleganceGauge.max_value * 0.1 
			elegance = 0
		$DecayTimer.start()

func _on_DecayTimer_timeout():
	if rank == C or B:
		$EleganceGauge.value -= 3
	elif rank == A:
		$EleganceGauge.value -= 6
	elif rank == S:
		$EleganceGauge.value -= 10
	elif rank == SS or SSS:
		$EleganceGauge.value -= 12
		
	$DecayTimer.start()
	if $EleganceGauge.value == $EleganceGauge.min_value and !is_attacking and rank != C and $RankDownDelayTimer.is_stopped():
		$DecayTimer.stop()
		$RankDownTimer.start()
		print("RANK DECREASED")



func _on_AttackDecayTimer_timeout():
	is_attacking = false


func _on_RankDownTimer_timeout():
	change_rank("Decrease")


func _on_HitCountResetTimer_timeout():
	reset_hitcount()
