class_name SulphuricSigil extends Node2D

const MAX_STACKS : int = 3
var stacks : int = 1
onready var stack1 = preload("res://assets/UI/sulphuric_sigil_1.png")
onready var stack2 = preload("res://assets/UI/sulphuric_sigil_2.png")
onready var stack3 = preload("res://assets/UI/sulphuric_sigil_3.png")

func _ready():
	modify_stacks(5)

func modify_stacks(amount : int):
	var total = stacks + amount
	if total > MAX_STACKS:
		stacks = MAX_STACKS
		$Sprite.texture = stack3
	else:
		stacks = total
		match stacks:
			1:
				$Sprite.texture = stack1
			2:
				$Sprite.texture = stack2
			3:
				$Sprite.texture = stack3
