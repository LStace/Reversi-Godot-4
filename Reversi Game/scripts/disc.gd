extends AnimatedSprite2D

var animations = ["light_resting", "dark_resting"]


func place(side):
	play(animations[int(side)])

func flip(side):
	play(animations[int(side)])
