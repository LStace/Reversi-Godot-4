extends ColorRect

signal hovered_over_tile(tile)

var board_index : Vector2i
var disc_scene : PackedScene = preload("res://scenes/disc.tscn")
var cur_disc : AnimatedSprite2D = null
var cur_colour : bool
var disc_animations = ["light_resting", "dark_resting"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$HoverIndicator.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	hovered_over_tile.emit(self)

#Places a disc of the player's colour on the tile
func place_disc(disc_colour):
	if cur_disc == null:
		var disc = disc_scene.instantiate()
		disc.position += (size/2)
		add_child(disc)
		cur_disc = disc
		cur_colour = disc_colour
		disc.play(disc_animations[int(cur_colour)])
