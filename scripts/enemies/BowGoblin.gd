class_name BowGoblin extends Goblin

var is_shooting : bool = false
const ARROW = preload("res://scenes/enemies/Arrow.tscn")

func _ready():
	$ShootArrowTimer.start()
	# Overrides
	max_HP = max_HP_calc * 0.75
	SPEED = MAX_SPEED / 4

func shoot_arrow():
	is_shooting = true
	$ShootArrowTimer.stop()
	$Sprite.play("BowAttacking")
	yield(get_tree().create_timer(2), "timeout")
	var arrow = ARROW.instance()
	get_parent().add_child(arrow)
	if !$Sprite.flip_h:
		arrow.x_direction = -1
		arrow.position.x = global_position.x + 10
	else:
		arrow.x_direction = 1
		arrow.position.x = global_position.x - 10
	arrow.position.y = global_position.y + 10
	is_shooting = false
	$ShootArrowTimer.start()

func _physics_process(delta):
	if !is_shooting:
		$Sprite.play("BowIdle")
	if !is_airborne:
		set_collision_mask_bit(2, true)
	else:
		set_collision_mask_bit(2, false)
	if flipped:
		$Sprite.flip_h = true
	if !is_airborne:
		velocity.y += GRAVITY
	if is_on_floor() and !is_shooting:
		
		if !is_staggered and !$Area2D.overlaps_area(PLAYER) and !other_enemy_detector_is_overlapping_player() and !is_frozen and !dead and !is_airborne and weakref(PLAYER).get_ref() != null: 
			if AREA_LEFT.overlaps_area(PLAYER) and !AREA_LEFT.overlaps_area(DECOY) and !AREA_LEFT.overlaps_area(DECOY2) and !AREA_LEFT.overlaps_area(DECOY3):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = SPEED
			elif AREA_LEFT.overlaps_area(DECOY) or AREA_LEFT.overlaps_area(DECOY2) or AREA_LEFT.overlaps_area(DECOY):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = SPEED 
			if AREA_RIGHT.overlaps_area(PLAYER) and !AREA_RIGHT.overlaps_area(DECOY) and !AREA_RIGHT.overlaps_area(DECOY2) and !AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = -SPEED 
			elif AREA_RIGHT.overlaps_area(DECOY) or AREA_RIGHT.overlaps_area(DECOY2) or AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = -SPEED
	if other_enemy_is_on_front():
		velocity.x = 0
		
	if $Area2D.overlaps_area(PLAYER) or other_enemy_is_on_front() and !is_staggered:

		if $Sprite.flip_h:
			velocity.x = SPEED * 1
		else:
			velocity.x = -SPEED * 1
	if other_enemy_detectors_is_overlapping():
		if $Sprite.flip_h:
			velocity.x = -SPEED 
		else:
			velocity.x = SPEED 
	if other_enemy_is_on_front():
		if other_enemy_detector_is_overlapping_player():
			if $Sprite.flip_h:
				velocity.x = -SPEED 
			else:
				velocity.x = SPEED
		elif AREA_LEFT.overlaps_area(PLAYER) or AREA_RIGHT.overlaps_area(PLAYER):
			if $Sprite.flip_h:
				velocity.x = -SPEED 
			else:
				velocity.x = SPEED
	if is_staggered or is_frozen or is_airborne:
		velocity.x = 0


func _on_ShootArrowTimer_timeout():
	if !is_dead and !is_frozen and !is_airborne:
		shoot_arrow()
