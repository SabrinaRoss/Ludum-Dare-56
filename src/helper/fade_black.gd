extends Node2D

@onready var animp = $AnimationPlayer

signal transition_finished

func cover_screen():
	animp.play("fadeToBlack")
	await animp.animation_finished
	emit_signal("transition_finished")

func reveal_screen():
	animp.play("fadeFromBlack")
	await animp.animation_finished
	emit_signal("transition_finished")
