extends CharacterBody2D
class_name Player

@onready var animp = $AnimationPlayer
@onready var transformables = $transformables

@onready var bullet_scene = preload("res://src/entities/player/player_bullet.tscn")
@onready var damage_indicator = preload("res://src/entities/player/Damage Indicator.tscn")

var bullet_speed = 300
var bullet_cooldown = 0.2
var parry_speed = 300

var max_health = 1
var cur_health = 1

var max_vel = 0

var input_acc = 0
var idle_deacc = 0
var turn_acc = 0

var roll_vel = 0
var bullet_timer = 0
var slash_damage = 1
var bullet_damage = 1
var parry_damage = 50

# 0 - ant
# 1 - beetle
# 2 - squirrel
@export var animal : int = 0

var input_vect = Vector2.ZERO
var action_just_pressed = false
var action_is_pressed = false
var roll_just_pressed = false

var facing_dir = Vector2.DOWN
var rolling = false
var parrying = false
var old_roll_dir = Vector2.DOWN

func _ready() -> void:
	Singleton.player = self
	match animal:
		# max_vel / x where x is the num of seconds to reach max_vel
		0:
			max_vel = 60
			input_acc = max_vel / 0.05
			idle_deacc = max_vel / 0.1
			turn_acc = max_vel / 0.02
			roll_vel = 250
			max_health = 5
		1:
			max_vel = 90
			input_acc = max_vel / 0.05
			idle_deacc = max_vel / 0.1
			turn_acc = max_vel / 0.02
			roll_vel = 500
			max_health = 100
		2:
			max_vel = 100
			input_acc = max_vel / 0.05
			idle_deacc = max_vel / 0.1
			turn_acc = max_vel / 0.02
			roll_vel = 500
			max_health = 1000
	
	cur_health = max_health

func _physics_process(delta: float) -> void:
	get_input()
	if not rolling and not parrying:
		calc_movement_physics(delta)
		do_actions()
	move_and_slide()
	tick_timers(delta)

func get_input():
	input_vect = Input.get_vector("left", "right", "up", "down")
	action_just_pressed = Input.is_action_just_pressed("action")
	action_is_pressed = Input.is_action_pressed("action")
	roll_just_pressed = Input.is_action_just_pressed("roll")
	facing_dir = (get_global_mouse_position() - global_position).normalized()

func update_facing(vect):
	if vect.x != 0:
		transformables.scale.x = vect.x / abs(vect.x)

func calc_movement_physics(delta):
	compute_axis("x", delta)
	compute_axis("y", delta)
	
	if animp.current_animation != "shoot" and animp.current_animation != "slash":
		update_facing(input_vect)
		if input_vect == Vector2.ZERO:
			animp.play("idle")
		else:
			animp.play("run")

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

func do_actions():
	if roll_just_pressed:
		rolling = true
		velocity = roll_vel * input_vect
		if input_vect == Vector2.ZERO:
			velocity = roll_vel * facing_dir
		old_roll_dir = facing_dir if input_vect == Vector2.ZERO else input_vect
		animp.play("RESET")
		animp.advance(0)
		update_facing(old_roll_dir)
		animp.play("roll")
	
	if action_just_pressed:
		match animal:
			0:
				slash()
			1:
				parry()

	if action_is_pressed and animal == 2 and bullet_timer <= 0:
		shoot()

func slash():
	var mouse_vect = (get_global_mouse_position() - global_position).normalized()
	$Hurtbox.rotation = mouse_vect.angle()
	update_facing(mouse_vect)
	animp.play("slash")

func parry():
	var mouse_vect = (get_global_mouse_position() - global_position).normalized()
	$transformables/ParryBox/CollisionShape2D.position = mouse_vect * 10
	parrying = true
	velocity = Vector2.ZERO
	update_facing(mouse_vect)
	animp.play("parry")

func bullet_parried(bullet_area : Area2D):
	var bullet = bullet_area.owner
	if bullet is Acorn:
		bullet.reflect()
		bullet.dir = facing_dir
		bullet.damage = parry_damage
		bullet.speed = parry_speed
	else:
		bullet.explode()

func shoot():
	var mouse_vect = (get_global_mouse_position() - global_position).normalized()
	update_facing(mouse_vect)
	animp.play("shoot")
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = global_position + mouse_vect * 10
	new_bullet.dir = facing_dir
	new_bullet.speed = bullet_speed
	new_bullet.damage = bullet_damage
	add_child(new_bullet)
	bullet_timer = bullet_cooldown

func slash_hit(target : Area2D):
	var enemy = target.owner
	enemy.take_damage(slash_damage)

func tick_timers(delta):
	bullet_timer -= delta

func take_damage(damage):
	cur_health -= damage
	Singleton.health_bar_scene.damageAnimation()
	#var dmg_ind = damage_indicator.instantiate()
	#dmg_ind.setIntensity(damage)
	#Singleton.main.curEffectsNode.add_child(dmg_ind)
	#dmg_ind.position = position
	#if cur_health <= 0:
		#Singleton.main.death()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"roll":
			rolling = false
			velocity = old_roll_dir * max_vel
		"parry":
			parrying = false
