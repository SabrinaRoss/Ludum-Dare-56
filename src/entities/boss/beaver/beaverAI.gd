extends Node

@onready var smite = preload("res://src/entities/boss/beaver/Smite.tscn")
@export var num_of_smites: int = 40


var player_near
var cur_body
var direction = Vector2(0, 0)
var check_dir_border = 1
var count = false
func _ready() -> void:
	player_near = $Player_near
# ace attack is gonna be the reality shift which is pretty hypers, and is gonna allow for manipulating the character and use some 
# fun shaders 

# main attack is gonna be the  smite where shoot down at player location 

# ace attack is where the player get tooo place and than they get chainsawed

func _physics_process(delta: float) -> void:
	$Player_near/Player_near_sprite.rotation_degrees += .5
func main_attack():
	if $"..".re_move:
		smite_player()
		if ($"..".health < 220):	
			smite_grid_lines_vertical()
		if ($"..".health < 170):
			smite_grid_lines_horizontal()
		if ($"..".health < 120):
			smite_random_position()
	
func smite_player():
	for i in num_of_smites:
		if (!$"..".attacking): return
		var instance = smite.instantiate()
		instance.scale *= .5
		instance.rotation_degrees = randi_range(0, 360)
		var timer = Timer.new()
		timer.wait_time = .2
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		instance.global_position = get_parent().get_parent().get_node("PlayerSquirell").position
		get_parent().get_parent().get_node("Projectiles").add_child(instance)

func smite_grid_lines_vertical():
	var viewport = get_tree().get_root().get_viewport().get_visible_rect()
	for i in roundi(viewport.end.x):
		if (!$"..".attacking): return
		if (i % 50 == randi_range(0, 50)):
			for j in roundi(viewport.end.y):
				if (j % 5 == 0):
					var timer = Timer.new()
					timer.wait_time = .005
					timer.one_shot = true
					add_child(timer)
					timer.start()
					await timer.timeout
					var instance = smite.instantiate()
					instance.scale *= .5
					instance.global_position = Vector2(i, j)
					instance.rotation_degrees = randi_range(0, 360)
					get_parent().get_parent().get_node("Projectiles").add_child(instance)

func smite_grid_lines_horizontal():
	var viewport = get_tree().get_root().get_viewport().get_visible_rect()
	for i in roundi(viewport.end.y):
		if (!$"..".attacking): return
		if (i % 50 == randi_range(0, 50)):
			for j in roundi(viewport.end.x):
				if (j % 5 == 0):
					var timer = Timer.new()
					timer.wait_time = .005
					timer.one_shot = true
					add_child(timer)
					timer.start()
					await timer.timeout
					var instance = smite.instantiate()
					instance.scale *= .5
					instance.global_position = Vector2(j, i)
					instance.rotation_degrees = randi_range(0, 360)
					get_parent().get_parent().get_node("Projectiles").add_child(instance)
					
func smite_random_position():
	for i in num_of_smites:
		if (!$"..".attacking): return
		var timer = Timer.new()
		timer.wait_time = .02
		timer.one_shot = true
		timer.connect("timeout", _on_timeout)
		add_child(timer)
		timer.start()
		await timer.timeout
		var instance = smite.instantiate()
		instance.scale *= .5
		var viewport = get_tree().get_root().get_viewport().get_visible_rect()
		instance.global_position = Vector2(randf_range(10, viewport.size.x -10), randf_range(10, viewport.size.y - 10))
		instance.rotation_degrees = randi_range(0, 360)
		get_parent().get_parent().get_node("Projectiles").add_child(instance)

func second_attack(): # proximity attack
	#play the animation
	# TODO: Do shit with the player when the player is more developed
	var player = cur_body.owner
	player.take_damage(999999999)
	var animation_player = $"../Hitbox/AnimationPlayer"
	if animation_player:
		animation_player.play("summon")
		$Timer_Player_Near.stop()
	
	pass

	
func _on_timeout(): #timeout for the smite
	pass
	


func _on_timer_player_near_timeout() -> void:
	second_attack()
	print("Hey DUde")


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	$Timer_Player_Near.start()
	$Player_near/Player_near_sprite.modulate = Color.RED
	$Player_near/Player_near_sprite.rotation_degrees += 10
	cur_body = area
	print("FUCK")


func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	$Timer_Player_Near.stop()
	$Player_near/Player_near_sprite.modulate = Color.WHITE
	$Player_near/Player_near_sprite.modulate.a = .10
	print("SHIT!")
