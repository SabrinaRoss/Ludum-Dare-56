extends Node2D
var background
var bar
var maxHealthColor = Color.GREEN
var minHealthColor = Color.RED
var maxDimensions = Vector2(40,40)
var displayHealth
var displayHealthChangeRate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = get_node("Background")
	bar = get_node("Background/Bar")
	maxHealthColor = Color.GREEN
	minHealthColor = Color.RED
	Singleton.health_bar_scene = self
	healthUpdate()
	

func healthUpdate() -> void:
	var percent = Singleton.player.cur_health/Singleton.player.max_health
	bar.color = lerp(minHealthColor,maxHealthColor,percent)
	var curDimensions = Vector2(maxDimensions.x*percent,maxDimensions.y)
	bar.size = curDimensions
	
func _input(_ev):
	if Input.is_key_pressed(KEY_1):
		Singleton.player.take_damage(0.5)
		healthUpdate()
