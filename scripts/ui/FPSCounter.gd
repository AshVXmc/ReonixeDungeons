extends CanvasLayer

var frametimes := []
var FPS : float = 0
var isvisible : bool = false

func _ready():
	$ColorRect.visible = false
	$Label.visible = false
func _process(delta):
	var current := OS.get_ticks_msec()
	while frametimes.size() > 0 and frametimes[0] <= current - 1000:
		frametimes.pop_front()
		
	frametimes.append(current)
	FPS = frametimes.size()
	$Label.text = "FPS:" + str(FPS)
	
	if Input.is_action_just_pressed("ui_fpscounter"):
		$Label.visible = true if !$Label.visible else false
		$ColorRect.visible = true if !$ColorRect.visible else false

	
