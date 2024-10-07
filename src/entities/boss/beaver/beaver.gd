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
var attacking: bool
var can_player_be_hit: bool = true
var state_on: bool = false
var second_phase: bool = true

var can_shader_bend: bool = true
var lo_shaders = []
var last_shader = ColorRect
func _ready() -> void:
	vel = Vector2.ZERO
	attacking = false
	health = 300.0 #make more later idk
	screenSize = get_viewport_rect().size
	$Ai/Player_near/Player_near_sprite.modulate.a = .10
	lo_shaders.append(get_parent().get_node("180p_Shader"))
	lo_shaders.append(get_parent().get_node("GreyScale_Shader"))
	lo_shaders.append(get_parent().get_node("Screenshake_Shader"))
	lo_shaders.append(get_parent().get_node("FlipScreen_Shader"))
	$Hitbox/AnimationPlayer.play("idle")
func _physics_process(delta: float) -> void:
	if (!attacking):
		position += vel * delta * 30
		position = position.clamp(-screenSize/2, screenSize/2)
		
		if (position.x > screenSize.x/2 - 20 or position.x < -screenSize.x/2 + 20):
			vel.x *= -1
		elif (position.y > screenSize.y/2 - 20 or position.y < -screenSize.y/2 + 20):
			vel.y *= -1
		var dir_vect = vel.normalized()
		update_facing(dir_vect)
		if !re_move:
			re_move = true
			move()
	else:
		var ai = get_node("Ai")
		if (health < 75):
			ace_attack()
		ai.main_attack()		
		re_move = false

func ace_attack():
	if re_move && can_shader_bend && second_phase: shader_include()
	pass
func move():
	var direction = rng.randi_range(0,4)
	vel = Vector2.ZERO
	match direction:
		0:
			vel = Vector2(1,1)
		1:
			vel = Vector2(-1,1)
		2:
			vel = Vector2(1,-1)
		3:
			vel = Vector2(-1,-1)
	
	

func shader_include():
	can_shader_bend = false
	var rand_shader = lo_shaders[rng.randi_range(0, lo_shaders.size() - 1)]
	if rand_shader == last_shader:
		return shader_include() #To any future employer, I am sorry about this line of code
	var timer = Timer.new()
	timer.wait_time =4
	timer.one_shot = true
	add_child(timer)
	timer.start()
	rand_shader.visible = true
	health += 10
	timer.timeout.connect(_on_timeout.bind(rand_shader))
func _on_timeout(rand_shader):
	rand_shader.visible = false
	can_shader_bend = true
	last_shader = rand_shader
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		death()

func death():
	Singleton.main.bossDeath()

func player_hit_restart():
	can_player_be_hit = false
	var timer = Timer.new()
	timer.wait_time = .5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	can_player_be_hit = true


func _on_state_changer_timeout() -> void:
	if (attacking):
		attacking = false
		$Hitbox/AnimationPlayer.play("idle")
		print("wddsa")
	elif (!attacking):
		attacking = true
		can_shader_bend = true
		$Hitbox/AnimationPlayer.play("summon")
		print("Simon was here")

func update_facing(dir : Vector2):
	if dir.dot(Vector2.RIGHT) < 0:
		$".".scale.x = 1
	else:
		$".".scale.x = -1
