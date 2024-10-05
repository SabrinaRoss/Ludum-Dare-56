extends CharacterBody2D
class_name Player

@onready var animp = $AnimationPlayer
@onready var transformables = $transformables

# 0 - ant
# 1 - beetle
# 2 - squirrel
var animal : int = 0

@export var max_vel = 100

# max_vel / x where x is the num of seconds to reach max_vel
@export var acc_time = 0.05
var input_acc = max_vel / acc_time
@export var idle_deacc_time = 0.1
var idle_deacc = max_vel / idle_deacc_time
@export var turn_acc_time = 0.02
var turn_acc = max_vel / turn_acc_time

@export var roll_vel = 200

var input_vect = Vector2.ZERO
var action_just_pressed = false
var roll_just_pressed = false

var facing_dir = Vector2.DOWN
var rolling = false

func _physics_process(delta: float) -> void:
	get_input()
	if not rolling:
		calc_movement_physics(delta)
	move_and_slide()

func get_input():
	input_vect = Input.get_vector("left", "right", "up", "down")
	action_just_pressed = Input.is_action_just_pressed("action")
	roll_just_pressed = Input.is_action_just_pressed("roll")

func calc_movement_physics(delta):
	compute_axis("x", delta)
	compute_axis("y", delta)
	if input_vect != Vector2.ZERO:
		facing_dir = input_vect
	
	if roll_just_pressed:
		rolling = true
		velocity = roll_vel * facing_dir
		animp.play("roll")
	
	transformables.global_rotation = (get_global_mouse_position() - global_position).angle()

func compute_axis(axis, delta):
	if input_vect[axis] == 0:
		velocity[axis] = move_toward(velocity[axis], 0, idle_deacc * delta)
	elif is_turning(axis):
		velocity[axis] = move_toward(velocity[axis], max_vel * input_vect[axis], turn_acc * delta)
	else:
		velocity[axis] = move_toward(velocity[axis], max_vel * input_vect[axis], input_acc * delta)

func is_turning(axis):
	return (input_vect[axis] < 0 and velocity[axis] > 0) or \
	 (input_vect[axis] > 0 and velocity[axis] < 0)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"roll":
			rolling = false
