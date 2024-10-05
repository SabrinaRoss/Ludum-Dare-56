extends Control

var main
var resumeButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resumeButton = get_node("Background/Resume Button")
	resumeButton.pressed.connect(_resumeButtonPressed)

func _resumeButtonPressed() -> void:
	main.togglePause()
