extends Node2D

var game_paused = false

var score = 0

signal game_paused_change(state)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		game_paused = !game_paused
		game_paused_change.emit(game_paused)

func _on_board_line_removed():
	score += 1
	$HUD.update_score(score)


func _on_hud_start_game():
	$Board.start_level()
