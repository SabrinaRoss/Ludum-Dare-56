extends Node2D
var background
var bar
var maxHealthColor = Color.GREEN
var minHealthColor = Color.RED
var maxDimensions = Vector2(120,20)
var displayHealth
var displayHealthDestination
var displayHealthChangeRate = 0.5
var scaleGoal = 1
var scaleStartSpeed = 0.1
var scaleVelocityChange = 0.035
var scaleVelocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = get_node("Background")
	bar = get_node("Background/Bar")
	maxHealthColor = Color.GREEN
	minHealthColor = Color.RED
	Singleton.health_bar_scene = self
	displayHealth = maxDimensions.x
	healthUpdate()

func damageAnimation() -> void:
	scaleVelocity = scaleStartSpeed
	scale += Vector2(1,1) * scaleVelocity

func healthUpdate() -> void:
	var percent = Singleton.player.cur_health/Singleton.player.max_health
	bar.color = lerp(minHealthColor,maxHealthColor,percent)
	displayHealthDestination = maxDimensions.x*percent
	var curDimensions = Vector2(displayHealth,maxDimensions.y)
	bar.size = curDimensions
	
func _input(_ev):
	if Input.is_key_pressed(KEY_1):
		Singleton.player.take_damage(0.5)
		healthUpdate()

func _process(_delta: float) -> void:
	var barDiff = displayHealth-displayHealthDestination
	if barDiff < 0:
		displayHealth -= displayHealthChangeRate*pow(barDiff/5,2) #ik its hardcoded but whatever
	else:
		displayHealth = displayHealthDestination
	healthUpdate()
	if scale.x <= scaleGoal:
		scale = Vector2(1,1) * scaleGoal
	else:
		scale += Vector2(1,1) * scaleVelocity
		scaleVelocity -= scaleVelocityChange
