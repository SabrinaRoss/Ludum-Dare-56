extends Node2D

var main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent()

func _on_button_pressed() -> void:
	main.fade_out_music()
	main.setLevel(0)
