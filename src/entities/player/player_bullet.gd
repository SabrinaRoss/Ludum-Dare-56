extends CharacterBody2D

var speed : float
var dir : Vector2

func _ready() -> void:
	velocity = dir * speed
	await get_tree().create_timer(5).timeout
	explode()

func _physics_process(delta: float) -> void:
	move_and_slide()

func explode():
	queue_free()
