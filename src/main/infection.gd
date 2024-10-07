extends Node2D
var speed = 0.1
var destination
var startPoint
var endPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPoint = get_node("Line2D").points[0]
	endPoint = get_node("Line2D").points[1]

func setDestination(bossPos) -> void:
	destination = Singleton.player.position - bossPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	endPoint += destination * speed
	pass
