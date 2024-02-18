extends ColorRect

signal hovered_over_tile(tile)

var board_index : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	$HoverIndicator.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	hovered_over_tile.emit(self)
