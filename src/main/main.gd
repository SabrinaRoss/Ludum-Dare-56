extends Node2D

var paused = false
var pauseMenuScene = load("res://src/main/Pause Menu.tscn")
var pauseMenu
var deathAnimationPlaying = false
var deathAnimationShrinkSpeed = 0.01

var level = 0
var mainMenuScene = load("res://src/main/Main Menu.tscn")
var level1Scene = load("res://src/main/Level 1.tscn")
var level2Scene = load("res://src/main/Level 2.tscn")
var level3Scene = load("res://src/main/Level 3.tscn")
var gameScene

var curEffectsNode
var curProjectilesNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Singleton.main = self
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
	curEffectsNode = gameScene.get_node("Effects")
	curProjectilesNode = gameScene.get_node("Projectiles")
	
func death() -> void:
	get_tree().paused = true
	deathAnimationPlaying = true

func _process(_delta: float) -> void:
	if deathAnimationPlaying:
		Singleton.player.scale -= Vector2(1,1) * deathAnimationShrinkSpeed
		if Singleton.player.scale.x <= 0:
			deathAnimationPlaying = false
			get_tree().paused = false
			setLevel(0)
