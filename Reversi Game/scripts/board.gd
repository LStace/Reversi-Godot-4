extends GridContainer

signal game_over
signal turn_started(winner)

var tiles_in_grid : Array[Array]
var current_tile = [null, Vector2i.ZERO]
var is_player_dark : bool = false
var turn : int = 1
var disc_totals : Array[int] = [0,0]
var can_move : Array[bool] = [true,true]

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
		i.board = self
		tile_number += 1
	
	start_turn()


#Handles input
func _input(event):
	
	#region move between tiles
	if event.is_action_pressed("move_up"):
		current_tile[1] += Vector2i.UP
	
	if event.is_action_pressed("move_right"):
		current_tile[1] += Vector2i.RIGHT
	
	if event.is_action_pressed("move_down"):
		current_tile[1] += Vector2i.DOWN
	
	if event.is_action_pressed("move_left"):
		current_tile[1] += Vector2i.LEFT
	
	if current_tile[1].x >= 8:
		current_tile[1].x = 0
	
	if current_tile[1].y >= 8:
		current_tile[1].y = 0
	
	on_hovered_over_tile(tiles_in_grid[current_tile[1].x][current_tile[1].y])
	
	#endregion
	
	if event.is_action_pressed("select"):
		if current_tile[0].legal_move:
			current_tile[0].place_disc(is_player_dark)
			turn += 1
			start_turn()
		else:
			current_tile[0].flash_illegal()


#Called when the player hovers over a tile and shows which tile is hovered over
func on_hovered_over_tile(tile):
	if current_tile[0] != null: current_tile[0].get_node("HoverIndicator").visible = false
	current_tile[0] = tile
	current_tile[1] = tile.board_index
	tile.get_node("HoverIndicator").visible = true


func start_turn():
	is_player_dark = !is_player_dark
	
	var temp_move_possible = false
	for tile in get_children():
		tile.on_turn_completed(is_player_dark, turn)
		if tile.legal_move:
			temp_move_possible = true
	
	can_move[int(is_player_dark)] = temp_move_possible
	
	if can_move[0] == false and can_move[1] == false:
		if disc_totals.max() != disc_totals.min():
			game_over.emit(disc_totals.find(disc_totals.max()))
		else:
			game_over.emit(2)
	
	elif can_move[int(!is_player_dark)] and not can_move[int(is_player_dark)]:
		start_turn()
	
	else:
		turn_started.emit()
