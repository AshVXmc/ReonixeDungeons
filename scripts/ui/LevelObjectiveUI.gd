extends CanvasLayer


# probably only used in endless
func initiative_wave_ui(wave : int):
	$WaveControl/WaveLabel.text = "Wave " + str(wave)
	$WaveControl.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	$WaveControl.visible = false

func objective_active(objective_text : String, timer_text : String, uses_timer : bool):
	$ObjectiveUI.visible = true
	$ObjectiveUI/ObjectiveLabel.text = objective_text
	if uses_timer:
		$TimerUI.visible = true
		$TimerUI/TimerLabel.text = timer_text
	
func objective_inactive():
	$ObjectiveUI.visible = false
	$TimerUI.visible = false
