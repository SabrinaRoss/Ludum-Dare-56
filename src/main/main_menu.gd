extends Control

var main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var startButton = get_node("Background/Start Button")
	main = get_parent()
	startButton.pressed.connect(startButtonPressed)

func startButtonPressed():
	main.startGame()
