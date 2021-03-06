class_name Spider extends KinematicBody2D


enum clingside {Down, Left, Right}
export (clingside) var Cling

var HP : int = 2
var velocity : Vector2 = Vector2()
var is_dead : bool = false 
var direction : int = 1
var jumping : int = 1
const TYPE : String = "Enemy"
const FLOOR_DOWN = Vector2(0, 1)
const FLOOR_LEFT = Vector2(-1, 0)
const SPEED : int = -100
const GRAVITY : int = -45
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")

func _ready():
	$JumpTimer.start()
func _physics_process(delta):
	if Cling == clingside.Down:
		if direction == 1 and !is_dead:
			$AnimatedSprite.flip_h = false
		elif !is_dead:
			$AnimatedSprite.flip_h = true
	if !is_dead:
		$AnimatedSprite.play("slimeanim")
	
	match Cling:
		clingside.Down:
			rotation_degrees = 180
			velocity.x = SPEED * direction
			velocity.y += GRAVITY
			velocity = move_and_slide(velocity, FLOOR_DOWN)
		clingside.Left:
			rotation_degrees = 90
			velocity.y = SPEED * direction
			velocity = move_and_slide(velocity, FLOOR_LEFT)
		
	
	if is_on_wall() or !$RayCast2D.is_colliding():
		if Cling == clingside.Down:
			direction *= -1
			$RayCast2D.position.x *= -1

func _on_Area2D_area_entered(area):
	if HP > 0:
		if area.is_in_group("Sword"):
			HP -= 1
			set_modulate(Color(2,0.5,0.3,1))
			velocity.x = 0
			$HurtTimer.start()
		elif area.is_in_group("Fireball"):
			HP -= 1
			set_modulate(Color(2,0.5,0.3,1))
			velocity.x = 0
			$HurtTimer.start()
		elif area.is_in_group("Sword2"):
			HP -= 3
			set_modulate(Color(2,0.5,0.3,1))
			velocity.x = 0
			$HurtTimer.start()
	
	drop_loot()
	
func drop_loot():
	var loot := LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint : int = lootrng.randi_range(1,4)
	if HP <= 0:
		if randomint == 1:
			get_parent().add_child(loot)
			loot.position = global_position
		queue_free()
		Global.enemies_killed += 1


func _on_HurtTimer_timeout():
	velocity.x = SPEED * direction
	set_modulate(Color(1,1,1,1))
