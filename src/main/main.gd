extends Node2D

var cur_music

var paused = false
var pauseMenuScene = preload("res://src/main/Pause Menu.tscn")
var pauseMenu
var deathAnimationPlaying = false
var deathAnimationShrinkSpeed = 0.01

var level = 0
var mainMenuScene = preload("res://src/main/Main Menu.tscn")
var level1Scene = preload("res://src/main/Level 1.tscn")
var level2Scene = preload("res://src/main/Level 2.tscn")
var level3Scene = preload("res://src/main/Level 3.tscn")
var win_scene = preload("res://src/main/win_scene.tscn")
var gameScene

var curEffectsNode
var curProjectilesNode

var infectionScene = preload("res://src/main/Infection.tscn")
var zoomOutAnimationPlaying = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Singleton.main = self
	Singleton.camera = get_node("Camera2D")
	setLevel(0)

func _input(_ev):
	if Input.is_action_just_pressed("pause"):
		togglePause()

func togglePause() -> void:
	if paused:
		pauseMenu.queue_free()
		paused = false
	elif level == 0:
		pauseMenu = pauseMenuScene.instantiate()
		pauseMenu.main = self
		add_child(pauseMenu)
		paused = true
	get_tree().paused = paused

func setLevel(newLevel) -> void:
	if gameScene != null:
		gameScene.queue_free()
	level = newLevel
	if level == 0:
		gameScene = mainMenuScene.instantiate()
	elif level == 1:
		gameScene = level1Scene.instantiate()
	elif level == 2:
		gameScene = level2Scene.instantiate()
	elif level == 3:
		gameScene = level3Scene.instantiate()
	elif level == 4:
		gameScene = win_scene.instantiate()
	add_child(gameScene)
	gameScene.process_mode = PROCESS_MODE_PAUSABLE
	if level != 0:
		curEffectsNode = gameScene.get_node("Effects")
		curProjectilesNode = gameScene.get_node("Projectiles")
	
	match level:
		1:
			$Music/BeetleIntro.play()
			cur_music = $Music/BeetleIntro
		2:
			$Music/SquirrelIntro1.play()
			cur_music = $Music/SquirrelIntro1
		3:
			$Music/BeaverLoop.play()
			cur_music = $Music/BeaverLoop
	
func getBoss():
	if level == 1:
		return gameScene.get_node("Beetle")
	elif level == 2:
		return gameScene.get_node("Squirrel")
	else:
		return gameScene.get_node("Beaver")
	
func death() -> void:
	fade_out_music()
	Engine.time_scale = 0.5
	deathAnimationPlaying = true
	var fb = Singleton.camera.get_node("FadeBlack")
	fb.cover_screen()
	await fb.transition_finished
	Engine.time_scale = 1
	get_tree().paused = true
	setLevel(level)
	fb.reveal_screen()
	deathAnimationPlaying = false
	await fb.transition_finished
	get_tree().paused = false

func bossDeath() -> void:
	get_tree().paused = true
	await fade_out_music()
	var boss = getBoss()
	var infection = infectionScene.instantiate()
	infection.destination = boss.position
	add_child(infection)
	infection.line.points[0] = Singleton.player.position
	infection.line.points[1] = Singleton.player.position
	await infection.done_stretching
	infection.queue_free()
	
	var zoom_amount = 150
	
	var t = create_tween().set_ease(Tween.EASE_IN)
	t.tween_property(gameScene, "scale", Vector2(zoom_amount, zoom_amount), 3)
	t.parallel().tween_property(gameScene, "global_position", -boss.get_node("ZoomMarker").global_position * zoom_amount, 3)
	
	await t.finished
	
	var trans = Singleton.camera.get_node("TransitionBosses")
	trans.cover_screen()
	await trans.transition_finished
	setLevel(level+1)
	gameScene.scale = Vector2(zoom_amount, zoom_amount)
	gameScene.global_position = Vector2.ZERO
	trans.reveal_screen()
	await trans.transition_finished
	
	t = create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(gameScene, "scale", Vector2(1, 1), 3)
	await t.finished
	get_tree().paused = false

func _process(_delta: float) -> void:
	if deathAnimationPlaying:
		Singleton.player.scale -= Vector2(1,1) * deathAnimationShrinkSpeed
	
	## at least for now I'm switching this to tweens because I can use them better
	## (I am of course willing to switch back!) - Avery
	
	#if zoomOutAnimationPlaying:
		#Singleton.camera.zoom -= Singleton.camera.zoom/4.0
		#if Singleton.camera.zoom.x < 1:
			#Singleton.camera.zoom = Vector2(1,1)
			#zoomOutAnimationPlaying = false

func fade_out_music():
	var old_val = cur_music.volume_db
	var t = create_tween()
	t.tween_property(cur_music, "volume_db", -30, 1)
	await t.finished
	cur_music.stop()
	cur_music.volume_db = old_val

func phase_change():
	await fade_out_music()
	match level:
		1:
			$Music/BeetleLoop2.play()
			cur_music = $Music/BeetleLoop2
		2:
			$Music/SquirrelIntro2.play()
			cur_music = $Music/SquirrelIntro2
			await cur_music.finished
			$Music/SquirrelLoop2.play()
			cur_music = $Music/SquirrelLoop2

func _on_beetle_intro_finished() -> void:
	$Music/BeetleLoop1.play()
	cur_music = $Music/BeetleLoop1

func _on_squirrel_intro_1_finished() -> void:
	$Music/SquirrelLoop1.play()
	cur_music = $Music/SquirrelLoop1
