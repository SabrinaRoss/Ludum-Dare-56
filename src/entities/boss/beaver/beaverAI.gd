extends Node

@onready var smite = preload("res://src/entities/boss/beaver/Smite.tscn")
@export var num_of_smites: int = 10
@export var crt_shader = load("res://src/entities/boss/beaver/crt.gdshader")
@export var noise_shader = load("res://src/entities/boss/beaver/noise.gdshader")
@export var pixelation_shader = load("res://src/entities/boss/beaver/noise.gdshader")
@export var tunnel_vision_shader = load("res://src/entities/boss/beaver/tunnel_vision.gdshader")

var player_near
var cur_body
var shaders
func _ready() -> void:
	player_near = $Player_near
	shaders = [crt_shader, noise_shader, pixelation_shader, tunnel_vision_shader]
# ace attack is gonna be the reality shift which is pretty hypers, and is gonna allow for manipulating the character and use some 
# fun shaders 

# main attack is gonna be the  smite where shoot down at player location 

# ace attack is where the player get tooo place and than they get chainsawed
var count = false
func _physics_process(_delta: float) -> void:
	
	if !count : main_attack()
	count = true
func main_attack():
	await smite_random_position(num_of_smites)
	return true
	
func smite_player():
	var instance = smite.instantiate()
	instance.global_position = get_tree().root.in_group("Player").position
	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	await timer.timeout
	add_child(timer)
	timer.start()
	add_child(instance)

func smite_random_position(count_number_smites: int):
	for i in count_number_smites:
		var timer = Timer.new()
		timer.wait_time = .15
		timer.one_shot = true
		timer.connect("timeout", _on_timeout)
		add_child(timer)
		timer.start()
		await timer.timeout
		var instance = smite.instantiate()
		var viewport = get_viewport().get_visible_rect()
		instance.global_position = Vector2(randf_range(0, viewport.size.x), randf_range(0, viewport.size.y))
		instance.rotation_degrees = randi_range(0, 360)
		add_child(instance)
	
	var timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	add_child(timer)
	timer.start()
	await timer.timeout
	count = false
func second_attack(): # proximity attack
	#play the animation
	# TODO: Do shit with the player when the player is more developed
	var player = cur_body.owner
	player.take_damage(999999999)
	pass

	
func ace_attack():
	var num_of_shaders = shaders.size
	var rand_shader = randi_range(0, num_of_shaders)
	
func _on_timeout(): #timeout for the smite
	pass
	

func _on_body_entered(body) -> void:
	$Timer_Player_Near.start()
	cur_body = body

func _on_body_exited(_body) -> void:
	$Timer_Player_Near.stop()

func _on_timer_player_near_timeout(_body) -> void:
	second_attack()
