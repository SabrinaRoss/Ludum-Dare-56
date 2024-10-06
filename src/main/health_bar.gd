extends Node2D
var background
var bar
var maxHealthColor
var minHealthColor
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = get_node("Background")
	bar = get_node("Background/Bar")
	maxHealthColor = Color.GREEN
	minHealthColor = Color.RED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.color = lerp(minHealthColor,maxHealthColor,0.5)
