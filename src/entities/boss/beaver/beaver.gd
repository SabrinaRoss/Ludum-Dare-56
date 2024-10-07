extends Node2D

var rng = RandomNumberGenerator.new()
var vel #Vector2
var screenSize
var re_move = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health
var shaders
var camera
var texture_rect


var second_phase: bool = true

var can_shader_bend: bool = true
var lo_shaders = []
var last_shader = ColorRect
func _ready() -> void:
	vel = Vector2.ZERO
	health = 100.0 #make more later idk
	screenSize = get_viewport_rect().size
	$Ai/Player_near/Player_near_sprite.modulate.a = .50
	lo_shaders.append(get_parent().get_node("180p_Shader"))
	lo_shaders.append(get_parent().get_node("GreyScale_Shader"))
	lo_shaders.append(get_parent().get_node("Screenshake_Shader"))
	lo_shaders.append(get_parent().get_node("FlipScreen_Shader"))
func _physics_process(delta: float) -> void:
	position += vel * delta * 20
	position = position.clamp(Vector2.ZERO, screenSize)
	
	if (position.x > screenSize.x -10 or position.x < 10):
		vel.x *= -1
	elif (position.y > screenSize.y - 10 or position.y < 10):
		vel.y *= -1
	if !re_move:
		re_move = true
		move()

func ace_attack():
	if can_shader_bend && second_phase: shader_include()
	pass
func move():
	var direction = rng.randi_range(0,4)
	match direction:
		0:
			vel = Vector2(1,1)
		1:
			vel = Vector2(-1,1)
		2:
			vel = Vector2(1,-1)
		3:
			vel = Vector2(-1,-1)
	
	await get_tree().create_timer(4.0).timeout
	vel = Vector2.ZERO
	re_move = false

func shader_include():
	can_shader_bend = false
	var rand_shader = lo_shaders[rng.randi_range(0, lo_shaders.size() - 1)]
	if rand_shader == last_shader:
		return shader_include() #To any future employer, I am sorry about this line of code
	var timer = Timer.new()
	timer.wait_time =10
	timer.one_shot = true
	add_child(timer)
	timer.start()
	rand_shader.visible = true
	timer.timeout.connect(_on_timeout.bind(rand_shader))
func _on_timeout(rand_shader):
	rand_shader.visible = false
	can_shader_bend = true
	last_shader = rand_shader
	
func take_damage(damage):
	health -= damage
	print(health)
