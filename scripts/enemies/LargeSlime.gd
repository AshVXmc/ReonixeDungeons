extends Slime

func _ready():
	HP = 5

func _physics_process(delta):
	_on_Area2D_area_entered($Area2D)
