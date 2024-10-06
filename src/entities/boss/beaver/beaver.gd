extends Node2D

var rng = RandomNumberGenerator.new()
var vel #Vector2
var screenSize
var re_move = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	vel = Vector2.ZERO
	screenSize = get_viewport_rect().size
	$Ai/Player_near/Player_near_sprite.modulate.a = .50
func _physics_process(delta: float) -> void:
	position += vel * delta * 15
	position = position.clamp(Vector2.ZERO, screenSize)
	
	
	if (position.x > screenSize.x -10 or position.x < 10):
		vel.x *= -1
	elif (position.y > screenSize.y - 10 or position.y < 10):
		vel.y *= -1
	if !re_move:
		re_move = true
		move()


	
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
