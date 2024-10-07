extends AnimationPlayer

signal animationFinished

func playAnimation():
	play("IntroAntInfection")
	await animation_finished
	emit_signal("animationFinished")
