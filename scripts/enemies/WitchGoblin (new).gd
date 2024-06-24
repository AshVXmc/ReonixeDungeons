class_name WitchGoblin extends Goblin


func summon_familiars():
	pass
func _physics_process(delta):
	if !is_airborne:
		set_collision_mask_bit(2, true)
	else:
		set_collision_mask_bit(2, false)
	if flipped:
		$Sprite.flip_h = true
	if !is_airborne:
		velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	if !$Sprite.flip_h:
		$OtherEnemyDetector.set_scale(Vector2(1,1))
		$SpearThrustAttackCollision.set_scale(Vector2(1,1))
	else:
		$OtherEnemyDetector.set_scale(Vector2(-1,1))
		$SpearThrustAttackCollision.set_scale(Vector2(-1,1))
	if 80 >= velocity.x and velocity.x >= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.play("Idle")
		if $Area2D.is_in_group("Hostile"):
			$Area2D.remove_from_group("Hostile") 
	else:
		yield(get_tree().create_timer(0.1), "timeout")
		$Sprite.play("Attacking")
		if !$Area2D.is_in_group("Hostile"):
			$Area2D.add_to_group("Hostile")
	if is_on_floor():
		if !is_staggered and !$Area2D.overlaps_area(PLAYER) and !other_enemy_detector_is_overlapping_player() and !is_frozen and !dead and !is_airborne and weakref(PLAYER).get_ref() != null: 
			if AREA_LEFT.overlaps_area(PLAYER) and !AREA_LEFT.overlaps_area(DECOY) and !AREA_LEFT.overlaps_area(DECOY2) and !AREA_LEFT.overlaps_area(DECOY3):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = -SPEED
			elif AREA_LEFT.overlaps_area(DECOY) or AREA_LEFT.overlaps_area(DECOY2) or AREA_LEFT.overlaps_area(DECOY):
				$Sprite.flip_h = false
				if !$Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = -SPEED 
			if AREA_RIGHT.overlaps_area(PLAYER) and !AREA_RIGHT.overlaps_area(DECOY) and !AREA_RIGHT.overlaps_area(DECOY2) and !AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.25),"timeout")
					velocity.x = SPEED 
			elif AREA_RIGHT.overlaps_area(DECOY) or AREA_RIGHT.overlaps_area(DECOY2) or AREA_RIGHT.overlaps_area(DECOY3):
				$Sprite.flip_h = true
				if $Sprite.flip_h:
					yield(get_tree().create_timer(0.5),"timeout")
					velocity.x = SPEED
	if other_enemy_is_on_front():
		velocity.x = 0
		
	if $Area2D.overlaps_area(PLAYER) or other_enemy_is_on_front() and !is_staggered:

		if $Sprite.flip_h:
			velocity.x = -SPEED * 1
		else:
			velocity.x = SPEED * 1
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
