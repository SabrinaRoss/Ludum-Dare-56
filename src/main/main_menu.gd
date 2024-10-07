extends Control

var main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent()


func startButtonPressed():
	main.get_node("Sound").get_node("button_press").play()
	main.do_intro()
	call_deferred("queue_free")

func _on_button_mouse_entered() -> void:
	main.get_node("Sound").get_node("button_hover").play()
