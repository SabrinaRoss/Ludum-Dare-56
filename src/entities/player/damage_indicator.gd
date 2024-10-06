extends Node2D
var fade = 0.05
var rateOfChange
var intensity
var goalScale
var sprite

func _ready() -> void:
	sprite = get_node("Sprite2D")

func setIntensity(i) -> void:
	intensity = i
	goalScale = intensity
	rateOfChange = goalScale/fade
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.modulate.a -= fade
	scale += Vector2(1,1) * fade
	if scale.x > goalScale:
		queue_free()
