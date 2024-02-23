extends Node2D

@export var board_grid : GridContainer
@export var game_over : ColorRect
@export var player_display : AnimatedSprite2D
@export var turn_count : Label
@export var light_total : Label
@export var dark_total : Label
@export var winner_label : Label
@export var light_final_total : Label
@export var dark_final_total : Label

var player_results_Names : Array = ["Light Wins", "Dark Wins", "Draw"]

# Called when the node enters the scene tree for the first time.
func _ready():
	board_grid.game_over.connect(on_game_over)
	board_grid.turn_started.connect(on_turn_started)


func on_game_over(winning_player):
	winner_label.text = player_results_Names[winning_player]
	light_final_total.text = str(board_grid.disc_totals[0])
	dark_final_total.text = str(board_grid.disc_totals[1])
	game_over.visible = true


func on_turn_started():
	if board_grid.turn == 1: player_display.place(board_grid.is_player_dark)
	else: player_display.flip(board_grid.is_player_dark)
	turn_count.text = str(board_grid.turn)
	light_total.text = str(board_grid.disc_totals[0])
	dark_total.text = str(board_grid.disc_totals[1])
