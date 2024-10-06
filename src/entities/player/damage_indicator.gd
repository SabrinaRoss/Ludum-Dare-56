extends Node2D
var scaleMultiplier = 3
var fade = 0.05
var opacityChange
var intensity
var goalScale
var sprite

func _ready() -> void:
	sprite = get_node("Sprite2D")

func setIntensity(i) -> void:
	intensity = i
	goalScale = intensity*scaleMultiplier
	opacityChange = fade/goalScale
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.modulate.a -= opacityChange
	scale += Vector2(1,1) * fade
	if scale.x > goalScale:
		queue_free()
