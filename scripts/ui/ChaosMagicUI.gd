class_name ChaosMagicUI extends Control

onready var player = get_parent().get_parent().get_node("Player")
const VERTICAL_JUMP_PARTICLE = preload("res://scenes/particles/VerticalJumpParticle.tscn") 
const MOTE_OF_FLAME = preload("res://scenes/misc/MoteOfFlame.tscn")

func _ready():
	pass
#	chaos_magic(4)

func trigger_chaos_magic():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, 10)
	chaos_magic(num)


func chaos_magic(id : int):
	match id:
		1:
			# A gust of wind propels you upward. knocking enemies way
			$NinePatchRect/DescLabel.text = "A gust of wind pushes you upwards, pushing enemies away."
			$NinePatchRect.visible = true
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
			var vjp = VERTICAL_JUMP_PARTICLE.instance()
			get_parent().get_parent().add_child(vjp)
			vjp.position = player.global_position
			vjp.emitting = true
			vjp.get_node("StrongJumpParticle").emitting = true
			player.velocity.y = player.JUMP_POWER * 1.35
			yield(get_tree().create_timer(0.65), "timeout")
			vjp.call_deferred('free')
		2:
			$NinePatchRect/DescLabel.text = "A small flame appears at your location, exploding after a short delay."
			$NinePatchRect.visible = true
			yield(get_tree().create_timer(0.6), "timeout")
			$NinePatchRect.visible = false
			var mote_of_flame = MOTE_OF_FLAME.instance()
			get_parent().get_parent().add_child(mote_of_flame)
			mote_of_flame.position = player.global_position
		3:
			$NinePatchRect/DescLabel.text = "You temporarily get frozen in place."
			$NinePatchRect.visible = true
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
			player.freeze_player(3)
			get_parent().get_parent().get_node("SkillsUI/Control").trigger_global_silence_ui(3)
		4:
			$NinePatchRect/DescLabel.text = "You gain a shield that absorbs damage, based on your party's average Max Health."
			# the shield's HP is based on the average HP of all party members
			$NinePatchRect.visible = true
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
			var list_of_party_member_levels : Array
			for c in Global.equipped_characters:
				if c != "":
					list_of_party_member_levels.append(Global.character_level_data[c][0])
			var level_mean : float
			for l in list_of_party_member_levels:
				level_mean += l
			level_mean = level_mean / (list_of_party_member_levels.size())
			
			print("Lv mean:" + str(level_mean))
			
			$NinePatchRect.visible = true
			yield(get_tree().create_timer(1), "timeout")
			$NinePatchRect.visible = false
