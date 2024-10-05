extends Node2D

var mainMenu
var paused = false
var pauseMenuScene = load("res://src/main/Pause Menu.tscn")
var pauseMenu

var level = 0
var playerAntScene = load("res://src/entities/player/player_ant.tscn")
var playerBeetleScene = load("res://src/entities/player/player_beetle.tscn")
var playerSquirrelScene = load("res://src/entities/player/player_squirrel.tscn")
var bossBeetleScene = load("res://src/entities/boss/Beetle.tscn")
var bossSquirrelScene = load("res://src/entities/boss/squirrel/squirrel.tscn")
#var bossBeaverScene = load("res://src/entities/boss/beaver/beaver.tscn")

var player
var boss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainMenu = get_node("MainMenu")
	
func startGame() -> void:
	mainMenu.queue_free()
	changeLevel(1,Vector2(0,0))

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

func changeLevel(newLevel, spawnPoint) -> void:
	clearScenes()
	level = newLevel
	spawnScenes(spawnPoint)

func spawnScenes(spawnPoint) -> void:
	if level == 1:
		player = playerAntScene.instantiate()
		boss = bossBeetleScene.instantiate()
	elif level == 2:
		player = playerBeetleScene.instantiate()
		boss = bossSquirrelScene.instantiate()
	#elif level == 3:
		#player = playerSquirrelScene.instantiate()
		#boss = bossBeaverScene.instantiate()
	add_child(player)
	add_child(boss)
	player.position = spawnPoint
		
func clearScenes() -> void:
	if player != null:
		player.queue_free()
	if boss != null:
		boss.queue_free()
	#put more specific cases for different levels when there are more things to destroy
		
		
