extends GridContainer

var tiles_in_grid : Array[Array]
var current_tile = [null, Vector2i.ZERO]
var move_buffer : float = 0.0

@onready var children = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	# construct the grid whithin the code
	tiles_in_grid.resize(8)
	for i in range(0,8):
		tiles_in_grid[i].resize(8)
	
	var tile_number = 0
	for i in get_children():
		tiles_in_grid[tile_number % 8][tile_number / 8] = i
		i.board_index = Vector2i(tile_number % 8, tile_number / 8)
		i.hovered_over_tile.connect(on_hovered_over_tile)
		tile_number += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Handles input to select diffferent tiles
func _input(event):
	if event.is_action_pressed("move_up"):
		current_tile[1] += Vector2i.UP
		#on_hovered_over_tile(tiles_in_grid[current_tile[1].x][current_tile[1].y + Vector2i.UP.y])
	
	if event.is_action_pressed("move_right"):
		current_tile[1] += Vector2i.RIGHT
		#on_hovered_over_tile(tiles_in_grid[current_tile[1].x + Vector2i.RIGHT.x][current_tile[1].y])
	
	if event.is_action_pressed("move_down"):
		current_tile[1] += Vector2i.DOWN
		#on_hovered_over_tile(tiles_in_grid[current_tile[1].x][current_tile[1].y + Vector2i.DOWN.y])
	
	if event.is_action_pressed("move_left"):
		current_tile[1] += Vector2i.LEFT
		#on_hovered_over_tile(tiles_in_grid[current_tile[1].x + Vector2i.LEFT.y][current_tile[1].y])
	
	if current_tile[1].x >= 8:
		current_tile[1].x = 0
	
	if current_tile[1].y >= 8:
		current_tile[1].y = 0
	
	on_hovered_over_tile(tiles_in_grid[current_tile[1].x][current_tile[1].y])


#Called when the player hovers over a tile and shows which tile is hovered over
func on_hovered_over_tile(tile):
	if current_tile[0] != null: current_tile[0].get_node("HoverIndicator").visible = false
	current_tile[0] = tile
	current_tile[1] = tile.board_index
	tile.get_node("HoverIndicator").visible = true