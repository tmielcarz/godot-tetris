extends Node2D

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_board_line_removed():
	score += 1
	$HUD.update_score(score)


func _on_hud_start_game():
	$Board.start_level()
