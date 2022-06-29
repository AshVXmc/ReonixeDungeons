class_name LargeSlime extends Slime

onready var area = $Area2D
onready var SLIME = preload("res://scenes/enemies/Slime.tscn")
const BLUE_SMOKE = preload("res://scenes/particles/BlueSmokeParticle.tscn")
func _ready():
	HP = 5

func spawn_slime():
	pass
func drop_loot():
#	var loot = LOOT.instance()
#	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
#	lootrng.randomize()
#	var randomint = lootrng.randi_range(1,4)
	if HP <= 0:
		var bp = BLUE_SMOKE.instance()
		var bp2 = BLUE_SMOKE.instance()
		get_parent().add_child(bp)
		bp.one_shot = true
		bp.position = global_position
		yield(get_tree().create_timer(0.25), "timeout")
		get_parent().add_child(bp2)
		bp2.one_shot = true
		bp2.position = global_position
		yield(get_tree().create_timer(0.75), "timeout")
		var slime1 = SLIME.instance()
		var slime2 = SLIME.instance()
		get_parent().add_child(slime1)
		get_parent().add_child(slime2)
		slime1.position = $SpawnSlime1.global_position
		slime2.position = $SpawnSlime2.global_position
		queue_free()
		Global.enemies_killed += 1
		
func _on_Area2D_area_entered(area : Area2D):
	if area.is_in_group("Sword") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		velocity.x = 0
		$HurtTimer.start()
	elif area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		velocity.x = 0
		$HurtTimer.start()
	elif area.is_in_group("Sword2") and HP > 0:
		HP -= 3
		set_modulate(Color(2,0.5,0.3,1))
		velocity.x = 0
		$HurtTimer.start()
	elif area.is_in_group("Frozen"):
		is_frozen = true
	drop_loot()

