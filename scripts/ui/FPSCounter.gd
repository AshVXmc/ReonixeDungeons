extends CanvasLayer

var frametimes := []
var FPS : float = 0
var isvisible = false


func _process(delta):
	var current := OS.get_ticks_msec()
	while frametimes.size() > 0 and frametimes[0] <= current - 1000:
		frametimes.pop_front()
		
	frametimes.append(current)
	FPS = frametimes.size()
	$Label.text = "FPS:" + str(FPS)
	
	if Input.is_action_just_pressed("ui_debug"):
		if !$Label.visible:
			$Label.visible = true
		else:
			$Label.visible = false

	