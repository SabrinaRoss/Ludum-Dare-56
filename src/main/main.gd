extends Node2D

var mainMenu
var paused = false
var pauseMenuScene = load("res://src/main/Pause Menu.tscn")
var pauseMenu

var level
var level1Scene = load("res://src/main/Level 1.tscn")
var level2Scene = load("res://src/main/Level 2.tscn")
var level3Scene = load("res://src/main/Level 3.tscn")
var gameScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainMenu = get_node("MainMenu")
	process_mode = PROCESS_MODE_ALWAYS
	
func startGame() -> void:
	mainMenu.queue_free()
	setLevel(1)

func _input(_ev):
	if Input.is_action_just_pressed("pause"):
		togglePause()
	
func togglePause() -> void:
	if paused:
		pauseMenu.queue_free()
		paused = false
	elif mainMenu == null:
		pauseMenu = pauseMenuScene.instantiate()
		pauseMenu.main = self
		add_child(pauseMenu)
		paused = true
	get_tree().paused = paused

func setLevel(newLevel) -> void:
	if gameScene != null:
		gameScene.queue_free()
	level = newLevel
	if level == 1:
		gameScene = level1Scene.instantiate()
	elif level == 2:
		gameScene = level2Scene.instantiate()
	elif level == 3:
		gameScene = level3Scene.instantiate()
	add_child(gameScene)
