extends Node2D

var mainMenu
var paused = false
var pauseMenuScene = load("res://src/main/Pause Menu.tscn")
var pauseMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainMenu = get_node("MainMenu")
func startGame() -> void:
	mainMenu.queue_free()

func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
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
		
