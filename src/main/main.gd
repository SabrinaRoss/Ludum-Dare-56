extends Node2D

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
	add_child(gameScene)
	gameScene.process_mode = PROCESS_MODE_PAUSABLE
	if level != 0:
		curEffectsNode = gameScene.get_node("Effects")
		curProjectilesNode = gameScene.get_node("Projectiles")
	
func getBoss():
	if level == 1:
		return gameScene.get_node("Beetle")
	elif level == 2:
		return gameScene.get_node("Squirrel")
	else:
		return gameScene.get_node("Beaver")
	
func death() -> void:
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
	var boss = getBoss()
	var infection = infectionScene.instantiate()
	add_child(infection)
	infection.destination = boss.position
	infection.line.points[0] = Singleton.player.position
	infection.line.points[1] = Singleton.player.position
	get_tree().paused = true
	var trans = Singleton.camera.get_node("TransitionBosses")
	trans.cover_screen()
	await trans.transition_finished
	infection.queue_free()
	setLevel(level+1)
	trans.reveal_screen()
	Singleton.camera.position = Vector2(0,0)
	await trans.transition_finished
	zoomOutAnimationPlaying = true
	get_tree().paused = false

func _process(_delta: float) -> void:
	if deathAnimationPlaying:
		Singleton.player.scale -= Vector2(1,1) * deathAnimationShrinkSpeed
	if zoomOutAnimationPlaying:
		Singleton.camera.zoom -= Singleton.camera.zoom/4.0
		if Singleton.camera.zoom.x < 1:
			Singleton.camera.zoom = Vector2(1,1)
			zoomOutAnimationPlaying = false
