extends Node2D

@onready var animp = $AnimationPlayer

signal transition_finished

func cover_screen():
	animp.play("transition_to_cover")
	await animp.animation_finished
	emit_signal("transition_finished")

func reveal_screen():
	animp.play("transtion_to_normal")
	await animp.animation_finished
	emit_signal("transition_finished")
