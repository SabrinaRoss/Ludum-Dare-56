extends Node

<<<<<<< HEAD
@onready var smite = preload("res://src/entities/Smite.tscn")
=======
@onready var smite = preload("res://src/entities/boss/beaver/Smite.tscn")
@export var num_of_smites: int = 10
@export var crt_shader = load("res://src/entities/boss/beaver/crt.gdshader")
@export var noise_shader = load("res://src/entities/boss/beaver/noise.gdshader")
@export var pixelation_shader = load("res://src/entities/boss/beaver/noise.gdshader")
@export var tunnel_vision_shader = load("res://src/entities/boss/beaver/tunnel_vision.gdshader")
>>>>>>> 52af5873bfc7cd39c02ed8cc18c9490a6fff07ca

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

func main_attack():
	var instance = smite.instance()
	self.global_position = get_tree().root.in_group("Player").position
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	await timer.time_left <= 0
	add_child(timer)
	timer.start()
	add_child(instance)

<<<<<<< HEAD
<<<<<<< HEAD
=======
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
>>>>>>> fcb77a7d650997bbaaf971c45eb452d0ddf4303c
=======
>>>>>>> 3a58bdfb8c7305aad066c93bf7ca5b3015278243
func second_attack(): # proximity attack
	if cur_body.is_in_group("Player"):
		#play the animation
		# TODO: Do shit with the player when the player is more developed
		pass
	pass
	
<<<<<<< HEAD
=======
func ace_attack():
	var num_of_shaders = shaders.size
	var rand_shader = randi_range(0, num_of_shaders)
	
>>>>>>> 52af5873bfc7cd39c02ed8cc18c9490a6fff07ca
func _on_timeout(): #timeout for the smite
	pass
	

func _on_body_entered(body) -> void:
	$Timer_Player_Near.start()
	cur_body = body

<<<<<<< HEAD
<<<<<<< HEAD

func _on_body_exited(body) -> void:
=======
func _on_body_exited(_body) -> void:
>>>>>>> fcb77a7d650997bbaaf971c45eb452d0ddf4303c
=======

func _on_body_exited(body) -> void:
>>>>>>> 3a58bdfb8c7305aad066c93bf7ca5b3015278243
	$Timer_Player_Near.stop()

func _on_timer_player_near_timeout(body) -> void:
	second_attack()
