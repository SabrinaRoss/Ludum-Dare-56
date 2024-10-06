extends CharacterBody2D

var health = 100

@onready var transformables = $Transformables

@onready var nut_scene = preload("res://src/entities/boss/squirrel/squirrel_nut.tscn")
@onready var acorn_scene = preload("res://src/entities/boss/squirrel/squirrel_acorn.tscn")
@onready var nut_circle = preload("res://src/entities/boss/squirrel/nut_circle.tscn")

# 0 - jump
# 1 - dash
# 2 - shotgun
# 3 - spinning ball
# 4 - spiral
# 5 - snipe
# 6 - frenzy
var state

var jump_destination = Vector2.ZERO
var nut_bounces = 0
var move_tween : Tween

var rest_timer = 0

func _ready() -> void:
	switch_states(0)

func _physics_process(delta: float) -> void:
	if rest_timer <= 0:
		physics_process_state()
		check_switch_state()

func physics_process_state():
	match state:
		0:
			jump_state_physics()
		1:
			dash_state_physics()
		2:
			shotgun_state_physics()
		3:
			spinning_ball_state_physics()
		4:
			spiral_state_physics()
		5:
			snipe_state_physics()
		6:
			frenzy_state_physics()

func switch_states(new_state):
	if state:
		exit_state()
	state = new_state
	enter_state()

func enter_state():
	match state:
		0:
			enter_jump_state()
		1:
			enter_dash_state()
		2:
			enter_shotgun_state()
		3:
			enter_spinning_ball_state()
		4:
			enter_spiral_state()
		5:
			enter_snipe_state()
		6:
			enter_frenzy_state()

func exit_state():
	match state:
		0:
			exit_jump_state()
		1:
			exit_dash_state()
		2:
			exit_shotgun_state()
		3:
			exit_spinning_ball_state()
		4:
			exit_spiral_state()
		5:
			exit_snipe_state()
		6:
			exit_frenzy_state()

func check_switch_state():
	match state:
		0:
			check_switch_jump_state()
		1:
			check_switch_dash_state()
		2:
			check_switch_shotgun_state()
		3:
			check_switch_spinning_ball_state()
		4:
			check_switch_spiral_state()
		5:
			check_switch_snipe_state()
		6:
			check_switch_frenzy_state()

func update_facing(dir : Vector2):
	if dir.dot(Vector2.RIGHT) < 0:
		transformables.scale.x = -1
	else:
		transformables.scale.x = 1

func shotgun():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	

## PHYSICS FUNCTIONS

func jump_state_physics():
	pass

func dash_state_physics():
	pass

func shotgun_state_physics():
	pass

func spinning_ball_state_physics():
	pass

func spiral_state_physics():
	pass

func snipe_state_physics():
	pass

func frenzy_state_physics():
	pass

## ENTER STATE FUNCTIONS

func enter_jump_state():
	pass

func enter_dash_state():
	pass

func enter_shotgun_state():
	pass

func enter_spinning_ball_state():
	pass

func enter_spiral_state():
	pass

func enter_snipe_state():
	pass

func enter_frenzy_state():
	pass

## EXIT STATE FUNCTIONS

func exit_jump_state():
	pass

func exit_dash_state():
	pass

func exit_shotgun_state():
	pass

func exit_spinning_ball_state():
	pass

func exit_spiral_state():
	pass

func exit_snipe_state():
	pass

func exit_frenzy_state():
	pass

## SWITCH STATE FUNCTIONS

func check_switch_jump_state():
	pass

func check_switch_dash_state():
	pass

func check_switch_shotgun_state():
	pass

func check_switch_spinning_ball_state():
	pass

func check_switch_spiral_state():
	pass

func check_switch_snipe_state():
	pass

func check_switch_frenzy_state():
	pass
