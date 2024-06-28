class_name WitchGoblin extends Goblin

const ELDRITCH_BLAST = preload("res://scenes/enemies/EnemyEldritchBlast.tscn")
onready var player = get_parent().get_node("Player")

func _ready():
	SPEED = MAX_SPEED / 1.5
	is_casting = true
func _physics_process(delta):
	if !is_casting:
		if is_on_floor():
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
	if is_casting:
		$Sprite.play("Casting")
	if is_staggered or is_frozen or is_airborne:
		velocity.x = 0
		

func cast_spell():
	is_casting = true
	yield(get_tree().create_timer(2), "timeout")
	eldritch_blast()
	
	
	
# summon a harmless cloud of smoke that bursts to deal damage after a short windup
func eldritch_hex():
	pass

# slows/snares the player, mediocre damage, tracks the player until
# it enters a radius, then starts a countdown timer
func eldritch_blast():
	var eb = ELDRITCH_BLAST.instance()
	get_parent().add_child(eb)
	eb.position = global_position
	is_casting = false

func _on_CastSpellTimer_timeout():
	var entities = $PlayerDetectorArea2D.get_overlapping_bodies()
	if player in entities:
		cast_spell()
