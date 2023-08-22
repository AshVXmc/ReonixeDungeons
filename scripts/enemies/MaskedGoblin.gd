class_name MaskedGoblin extends KinematicBody2D

const max_HP : int = 25
export var HP : int = 25
export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
const FLOOR = Vector2(0, -1)
var SPEED : int = 320
const GRAVITY : int = 45
const SHURIKEN : PackedScene = preload("res://scenes/enemies/bosses/Shuriken.tscn")
const SMOKE_PARTICLE = preload("res://scenes/particles/SmokeParticle.tscn")
const SLOWING_POISON = preload("res://scenes/enemies/bosses/SlowingPoison.tscn")
const DEATH_PARTICLE = preload("res://scenes/particles/DeathSmokeParticle.tscn")
var is_staggered : bool = false
var is_knocked_back :bool = false
var is_invulnerable : bool = false
var repulsion = Vector2()
var invisible : bool
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var hb_full = preload("res://assets/UI/healthbar_full.png")
onready var hb_half = preload("res://assets/UI/healthbar_half.png")
onready var hb_critical = preload("res://assets/UI/healthbar_critical.png")
signal dead(time)
var dead : bool = false

func _ready():
	
	connect("dead", get_parent(), "death")
	$HealthBar.texture_progress = hb_full
	$ShootTimer.start()
	$ShieldBubble.visible = false

func _physics_process(delta):
	# Health bar stuff
	update_healthbar_value()
	# Main movement code
	if flipped:
		$AnimatedSprite.flip_h = true
	if invisible:
		$AnimatedSprite.visible = false
		$HealthBar.visible = false
	else:
		$AnimatedSprite.visible = true
		$HealthBar.visible = true
	if is_invulnerable:
		$ShieldBubble.visible = true
	else:
		$ShieldBubble.visible = false
	if !dead:
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
	$AnimatedSprite.play("default")
	if !is_staggered and !is_invulnerable and !dead:
		
		if $Left.overlaps_area(PLAYER):
			$AnimatedSprite.flip_h = false
			if !$AnimatedSprite.flip_h and !is_knocked_back:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = -SPEED
			if velocity.x == 0:
				is_knocked_back = true
				velocity.x = SPEED * 2
		if $Right.overlaps_area(PLAYER):
			$AnimatedSprite.flip_h = true
			if $AnimatedSprite.flip_h and !is_knocked_back:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = SPEED
			if velocity.x == 0:
				velocity.x = -SPEED * 2
		
	if is_staggered or dead or is_invulnerable:
		velocity.x = 0

func update_healthbar_value():
	$HealthBar.texture_progress = hb_full
	if $HealthBar.value < $HealthBar.max_value * 0.75:
		$HealthBar.texture_progress = hb_half
	if $HealthBar.value < $HealthBar.max_value * 0.25:
		$HealthBar.texture_progress = hb_critical

func _on_Area2D_area_entered(area):
	if area.is_in_group("Fireball") and HP > 0 and !is_knocked_back:
		invisible = false
		$SmokeBombTimer.stop()
		if !is_invulnerable:
			HP -= 1
			$HealthBar.value -= 1
			if HP % 5 == 0 and HP != 0:
				print("HP is multiple of 5 now")
				is_staggered = true
				knockback_smoke()
			is_staggered = true
			velocity.x = 0
			$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
			$HurtTimer.start()
			
		if HP == 0:
			invisible = false
			dead()
	if area.is_in_group("Sword"):
		invisible = false
		$SmokeBombTimer.stop()
		if !is_invulnerable:
			HP -= 1
			$HealthBar.value -= 1
			if HP % 5 == 0 and HP != 0:
				print("HP is multiple of 5 now")
				is_staggered = true
				knockback_smoke()
			is_staggered = true
			velocity.x = 0
			$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
			$HurtTimer.start()
			
		if HP == 0:
			invisible = false
			dead()
	if area.is_in_group("Sword2"):
		invisible = false
		$SmokeBombTimer.stop()
		if !is_invulnerable:
			HP -=4
			$HealthBar.value -= 4
			is_staggered = true
			velocity.x = 0
			$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
			$HurtTimer.start()
		if HP == 0:
			invisible = false
			dead()
	if area.is_in_group("Player") and !is_knocked_back:
		if invisible:
			invisible = false
			$SmokeBombTimer.stop()
		is_staggered = true
		yield(get_tree().create_timer(1), "timeout")
		is_staggered = false


func dead():
	is_staggered = true
	dead = true
	$Area2D/CollisionShape2D.disabled = true
	$Left/CollisionShape2D.disabled = true
	$Right/CollisionShape2D.disabled = true
	$ShootTimer.stop()
	$HurtTimer.stop()
	$AttackingTimer.stop()
	$BufferTimer.stop()
	$SmokeBombTimer.stop()
	$AnimatedSprite.visible = true
	death_animation()

func death_animation():
	$AnimationPlayer.play("Death")

	var p1 = DEATH_PARTICLE.instance()
	var p2 = DEATH_PARTICLE.instance()
	var p3 = DEATH_PARTICLE.instance()
	get_parent().add_child(p1)
	p1.emitting = true
	p1.one_shot = true
	p1.position = global_position
	yield(get_tree().create_timer(0.5), "timeout")
	get_parent().add_child(p2)
	p2.emitting = true
	p2.one_shot = true
	p2.position = global_position
	get_parent().add_child(p3)
	p3.emitting = true
	p3.one_shot = true
	p3.position = global_position
	yield(get_tree().create_timer(0.75), "timeout")
	get_parent().get_node("Plaque/Control").visible = true
	emit_signal("dead", get_parent().get_node("CountdownTimer").time_left)
	if !Global.masked_goblin_defeated:
		Global.masked_goblin_defeated = true
	queue_free()
func _on_HurtTimer_timeout():
	$AnimatedSprite.set_modulate(Color(1,1,1,1))
	is_staggered = false

func _on_AttackingTimer_timeout():
	velocity.x = 0


# SIGN TIP:
# The player can attack shurikens to gain mana
func _on_ShootTimer_timeout():
	attack()

func leap():
	velocity.y = -1000
	yield(get_tree().create_timer(0.4), "timeout")
	velocity.y = 0

func knockback_smoke():
	$ShootTimer.stop()
	is_invulnerable = true
	is_staggered = true
	$BossChargingParticle.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$CloseBlastArea/CollisionShape2D.disabled = false
	$BossChargingParticle.visible = false
	$SlowPoisonBlastParticle.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$ShootTimer.start()
	is_staggered = false
	is_invulnerable = false
	$CloseBlastArea/CollisionShape2D.disabled = true
	$SlowPoisonBlastParticle.visible = false
func attack():
	is_staggered = true
	velocity.x = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randint = rng.randi_range(1,3)
	match randint:
		1:
			spread_attack(true) if !$AnimatedSprite.flip_h else spread_attack(false)
			yield(get_tree().create_timer(1), "timeout")
			is_staggered = false
			$ShootTimer.start()
			var rng2 = RandomNumberGenerator.new()
			rng2.randomize()
			var randint2 = rng2.randi_range(1, 2)
			if !invisible:
				match randint2:
					1:
						smoke_bomb()
					2:
						leap()
		2:
			barrage(true) if !$AnimatedSprite.flip_h else barrage(false)
			yield(get_tree().create_timer(1), "timeout")
			is_staggered = false
			$ShootTimer.start()
			var rng2 = RandomNumberGenerator.new()
			rng2.randomize()
			var randint2 = rng2.randi_range(1, 2)
			if !invisible:
				match randint2:
					1:
						smoke_bomb()
					2:
						leap()
		3:
			throw_slowing_poison()
	
func smoke_bomb():
	is_staggered = true
	var smoke1 = SMOKE_PARTICLE.instance()
	var smoke2 = SMOKE_PARTICLE.instance()
	get_parent().add_child(smoke1)
	smoke1.position = global_position
	smoke1.emitting = true
	smoke1.one_shot = true
	yield(get_tree().create_timer(0.25), "timeout")
	get_parent().add_child(smoke2)
	smoke2.position = global_position
	smoke2.emitting = true
	smoke2.one_shot = true
	yield(get_tree().create_timer(0.25), "timeout")
	invisible = true
	$SmokeBombTimer.start()

func barrage(left : bool):
	var sh1 : Shuriken = SHURIKEN.instance()
	var sh3 : Shuriken = SHURIKEN.instance()

	
	sh1.flip_shuriken_direction(-1) if left else false
	get_parent().add_child(sh1)
	sh1.position = $LeftPos.global_position if left else $RightPos.global_position
	yield(get_tree().create_timer(0.5), "timeout")
	sh3.is_up = true
	get_parent().add_child(sh3)
	sh3.position = $UpPos.global_position
	yield(get_tree().create_timer(0.25), "timeout")

	is_staggered = false
	$ShootTimer.start()
func spread_attack(left : bool):
	var sh1 : Shuriken = SHURIKEN.instance()
	var sh2 : Shuriken = SHURIKEN.instance()
	var sh3 : Shuriken = SHURIKEN.instance()
	var sh4 : Shuriken = SHURIKEN.instance()
	var sh5 : Shuriken = SHURIKEN.instance()
	sh1.flip_shuriken_direction(-1) if left else false
	get_parent().add_child(sh1)
	sh1.position = $LeftPos.global_position if left else $RightPos.global_position
	
	sh2.flip_shuriken_direction(-1) if left else false
	sh2.right_up = true
	get_parent().add_child(sh2)
	sh2.position = $LeftPos.global_position if left else $RightPos.global_position
	
	sh3.flip_shuriken_direction(-1) if left else false
	sh3.left_up = true
	get_parent().add_child(sh3)
	sh3.position = $LeftPos.global_position if left else $RightPos.global_position
	sh4.flip_shuriken_direction(-1) if left else false
	sh4.left_up_2 = true
	get_parent().add_child(sh4)
	sh4.position = $LeftPos.global_position if left else $RightPos.global_position
	sh5.flip_shuriken_direction(-1) if left else false
	sh5.right_up_2 = true
	get_parent().add_child(sh5)
	sh5.position = $LeftPos.global_position if left else $RightPos.global_position
	
	
func throw_slowing_poison():
	var slowing_poison = SLOWING_POISON.instance()
	get_parent().add_child(slowing_poison)
	slowing_poison.position = $SlowingPoisonPos.global_position
	yield(get_tree().create_timer(0.75), "timeout")
	barrage(true) if !$AnimatedSprite.flip_h else barrage(false)

func _on_Left_area_exited(area):
	yield(get_tree().create_timer(1.2), "timeout")
	velocity.x = SPEED


func _on_Right_area_exited(area):
	yield(get_tree().create_timer(1.2), "timeout")
	velocity.x = -SPEED

func _on_BufferTimer_timeout():
	is_knocked_back = false


func _on_SmokeBombTimer_timeout():
	invisible = false
