extends AnimatedSprite2D

var animations = [["light_resting", "dark_light_flip"], ["dark_resting", "light_dark_flip"]]


func place(side):
	play(animations[int(side)][0])

func flip(side):
	play(animations[int(side)][1])
	#play(animations[int(side)][0])
	
