extends CanvasLayer

signal start_game

@export var l_block_left: PackedScene
@export var z_block_left: PackedScene
@export var i_block: PackedScene
@export var square_block: PackedScene

var blocks = {}

var next_block

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks[l_block_left._bundled.names[0]] = l_block_left
	blocks[z_block_left._bundled.names[0]] = z_block_left
	blocks[i_block._bundled.names[0]] = i_block
	blocks[square_block._bundled.names[0]] = square_block

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_score(score):
	$ScoreValue.text = str(score)

func _on_start_button_pressed():
	$StartButton.disabled = true
	start_game.emit()

func _on_board_next_block_drawed(block_name):
	if next_block != null:
		remove_child(next_block)
	
	next_block = blocks[block_name].instantiate()
	next_block.position = Vector2(240, 250)
	next_block.locked = true
	add_child(next_block)

func _on_main_game_paused_change(state):
	if state:
		$MessageLabel.text = "PAUSED"
	else:
		$MessageLabel.text = ""
		

func _on_board_board_full():
	$MessageLabel.text = "GAME OVER"
