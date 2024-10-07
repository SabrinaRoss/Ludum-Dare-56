extends Control

var main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent()


func startButtonPressed():
	main.setLevel(1)
