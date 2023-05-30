class_name TutorialLevel extends Level

const GOBLIN = preload("res://scenes/enemies/Goblin.tscn")
var page : int = 1
var keybinds = {
	
	ui_attack = InputMap.get_action_list("ui_attack")[0].as_text(),
	ui_dash = InputMap.get_action_list("ui_dash")[0].as_text(),
	ui_up = InputMap.get_action_list("ui_up")[0].as_text(),
	ui_down = InputMap.get_action_list("ui_down")[0].as_text(),
	jump = InputMap.get_action_list("jump")[0].as_text(),
	left = InputMap.get_action_list("left")[0].as_text(),
	right = InputMap.get_action_list("right")[0].as_text(),
	ui_skip = InputMap.get_action_list("ui_skip")[0].as_text()
}


var tutorials = {
	movement = "[center][color=#ffd703]Hold "+ keybinds.left +"[/color] and [color=#ffd703]"+ keybinds.right +"[/color] to move left and right. Tap [color=#ffd703]"+ keybinds.jump +"[/color] to jump and[color=#ffd703] " + keybinds.ui_dash + " [/color]to dash.",
	attacking = "[center][color=#ffd703]Tap " + keybinds.ui_attack + "[/color] to perform melee basic attacks. [color=#ffd703]Hold " + keybinds.ui_attack + " [/color]to perform a more powerful charged attack.[/center]",
	ex_charged_atk = "[center]Attacks build up your [color=red]Energy[/color]. When [color=red]Energy[/color] is full, [color=#ffd703]Hold " + keybinds.ui_attack + "[/color] to perform an [color=#ffd703]EX Charged Attack[/color][/center]",
	aerial_combat = "[center][color=#ffd703]Hold " + keybinds.ui_attack + "[/color] while [color=#ffd703]holding " + keybinds.ui_up + "[/color] to knock enemies airborne and do aerial combat.[/center]",
	aerial_combat_2 = "[center]Your attacks are enhanced while airborne. [color=#ffd703]Hold " + keybinds.ui_attack + " [/color]while airborne to unleash [color=#ffd703]Aerial Charged Attacks[/color].[/center]"
}

func _ready():
	$Control/TutorialLabel.bbcode_text = tutorials.movement
	$Control/PressToSkipLabel.bbcode_text = "[center]TAP [color=#ffd703]"+ keybinds.ui_skip +" [/color]FOR NEXT[/center]"

func _process(delta):
	if Input.is_action_just_pressed("ui_skip"):
		skip_to_next_dialogue()


func skip_to_next_dialogue():
	page += 1
	match page:
		1:
			$Control/TutorialLabel.bbcode_text = tutorials.movement
		2:
			$Control/TutorialLabel.bbcode_text = tutorials.attacking
			yield(get_tree().create_timer(0.4), "timeout")
			spawn_goblin()
		3:
			kill_all_enemies()
			$Control/TutorialLabel.bbcode_text = tutorials.ex_charged_atk
			get_node("Player").update_energy_meter(999)
			yield(get_tree().create_timer(0.4), "timeout")
			spawn_goblin()
		4:
			kill_all_enemies()
			$Control/TutorialLabel.bbcode_text = tutorials.aerial_combat
			get_node("Player").update_energy_meter(0)
			yield(get_tree().create_timer(0.4), "timeout")
			spawn_goblin()
		5:
			kill_all_enemies()
			$Control/TutorialLabel.bbcode_text = tutorials.aerial_combat_2
			get_node("Player").airborne_mode = false
			get_node("Player").update_energy_meter(0)
			yield(get_tree().create_timer(0.4), "timeout")
			spawn_goblin()

func spawn_goblin():
	var goblin = GOBLIN.instance()
	add_child(goblin)
	# Goblin is slowed because tutorial level duh
	goblin.SPEED *= 0.5
	goblin.position = $EnemySpawnPosition.global_position


func kill_all_enemies():
	for e in get_tree().get_nodes_in_group("Enemy"):
		e.call_deferred('free')
