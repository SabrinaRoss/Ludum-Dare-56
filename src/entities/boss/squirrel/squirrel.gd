extends CharacterBody2D

var health = 100

# 0 - jump
# 1 - dash
# 2 - shotgun
# 3 - spinning ball
# 4 - spiral
# 5 - snipe
# 6 - frenzy
var state

var nut_bounces = 0
var jump_destination = Vector2()

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
	pass

func exit_state():
	pass

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

## PHYSICS FUNCTIONS

func dash_state_physics():
	pass

func jump_state_physics():
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
