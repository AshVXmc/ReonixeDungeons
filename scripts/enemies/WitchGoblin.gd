class_name WitchGoblin extends Goblin

const ELDRITCH_BLAST = preload("res://scenes/enemies/EnemyEldritchBlast.tscn")
const ELDRITCH_HEX = preload("res://scenes/enemies/EnemyEldritchHex.tscn")
onready var player = get_parent().get_node("Player")

var spell_history : Array = []

func _ready():
	max_HP *= 0.7
	HP = max_HP
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value
	SPEED = MAX_SPEED / 2.1
	is_casting = true
	
	print(spell_history)
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
	yield(get_tree().create_timer(1), "timeout")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, 2)	
	match num:
		1:
			eldritch_blast()
			
		2:
			eldritch_hex()
	

# slows/snares the player, mediocre damage, tracks the player until
# it enters a radius, then starts a countdown timer
func eldritch_blast():
	var eb = ELDRITCH_BLAST.instance()
	get_parent().add_child(eb)
	eb.position = global_position
	yield(get_tree().create_timer(1),"timeout")
	is_casting = false
	
# summon a smokecloud at the player's position, before casting down lighting
func eldritch_hex():
	var hex = ELDRITCH_HEX.instance()
	get_parent().add_child(hex)
	hex.position = player.global_position
	yield(get_tree().create_timer(3.25), "timeout")
	is_casting = false
	
func _on_CastSpellTimer_timeout():
	var entities = $PlayerDetectorArea2D.get_overlapping_bodies()
	if player in entities:
		cast_spell()
