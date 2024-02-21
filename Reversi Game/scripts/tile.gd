extends ColorRect

signal hovered_over_tile(tile)

var board_index : Vector2i
var disc_scene : PackedScene = preload("res://scenes/disc.tscn")
var cur_disc : AnimatedSprite2D = null
var cur_colour : bool
var disc_animations = ["light_resting", "dark_resting"]
var legal_move : bool = false
var flip_tiles : Array
var board = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$HoverIndicator.visible = false


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
		
		board.disc_totals[int(cur_colour)] += 1
		
		for tile in flip_tiles:
			tile.flip_disc()


#Flips the disc that is on this tile if it is caught
func flip_disc():
	board.disc_totals[int(cur_colour)] -= 1
	cur_colour = not cur_colour
	cur_disc.play(disc_animations[int(cur_colour)])
	board.disc_totals[int(cur_colour)] += 1


# checks if the player can place a disc here
func on_turn_completed(player_colour, turn):
	flip_tiles.clear()
	legal_move = false
	
	if cur_disc == null and board != null:
		if turn > 4:
			#check that a line of opposing discs between two player discs will be created
			var directions = [
				Vector2i.UP,
				Vector2i(1,-1),
				Vector2i.RIGHT,
				Vector2i(1,1),
				Vector2i.DOWN,
				Vector2i(-1,1),
				Vector2i.LEFT,
				Vector2i(-1,-1)
			]
			
			for dir in directions:
				var temp_flip_tiles : Array
				for i in range(1,8):
					# check that the tile to check is in the board range
					if (
							board_index.x + (dir.x * i) < 0 or
							board_index.x + (dir.x * i) >= 8 or 
							board_index.y + (dir.y * i) < 0 or
							board_index.y + (dir.y * i) >= 8  
					):
						break
					# checks that a line can be made and stores all discs that could be flipped
					var checkTile = board.tiles_in_grid[board_index.x + (dir.x * i)][board_index.y + (dir.y * i)]
					if checkTile.cur_disc != null:
						if checkTile.cur_colour == not player_colour:
							temp_flip_tiles.append(checkTile)
						elif i != 1:
							legal_move = true
							for tile in temp_flip_tiles:
								flip_tiles.append(tile)
							break
						else:
							break
					else:
						break
		# check that tile is in the centre of the board
		elif (
				(board_index.x == 3 or board_index.x == 4)
				and (board_index.y == 3 or board_index.y == 4)
		):
			legal_move = true
		
