extends Node2D

@export var locked_segment: PackedScene
@export var l_block_left: PackedScene
@export var l_block_right: PackedScene
@export var z_block_left: PackedScene
@export var z_block_right: PackedScene
@export var i_block: PackedScene
@export var t_block: PackedScene
@export var square_block: PackedScene

var blocks = {}

var current_speed

var current_block

var next_block_id

var locked_segments

signal line_removed

signal next_block_drawed(block_name)

signal board_full

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks[0] = l_block_left
	blocks[1] = l_block_right
	blocks[2] = z_block_left
	blocks[3] = z_block_right
	blocks[4] = i_block
	blocks[5] = t_block
	blocks[6] = square_block

func start_level():
	current_speed = 50
	_prepare_locked_segments()
	_draw_next_block()
	_activate_current_block()

func _prepare_locked_segments():
	locked_segments = []
	for i in range(16):
		locked_segments.append([])
		for j in range(16):
			locked_segments[i].append([])
			locked_segments[i][j] = null

func _remove_locked_segments_if_full_lines():
	for i in range(16):
		var count = 0
		for j in range(16):
			var value = 1 if locked_segments[j][i] != null else 0
			count += value
		if count == 16:
			_remove_full_line(i)
			line_removed.emit() # TODO dodac punkty, wywolac animacje
			current_speed += 10

func _move_locked_segments(line):
	var found = false
	for row in range(line + 1, 16):
		for col in range(16):
			locked_segments[col][row - 1] = locked_segments[col][row]
			if locked_segments[col][row - 1] != null:
				locked_segments[col][row - 1].position.y += 64
				found = true

	for col in range(16):
		locked_segments[col][15] = null
		
	return found

func _update_board():
	for row in range(16):
		var count = 0
		for col in range(16):
			var value = 1 if locked_segments[col][row] == null else 0
			count += value
		if count == 16:
			return _move_locked_segments(row)

	return false

func _remove_full_line(line):
	for j in range(16):
		remove_child(locked_segments[j][line])
		locked_segments[j][line] = null

func _activate_current_block():
	current_block = blocks[next_block_id].instantiate()
	current_block.position = Vector2(32, -992)
	current_block.connect("block_locked", _on_block_locked)
	current_block.speed = current_speed
	add_child(current_block)
	_draw_next_block()

func _draw_next_block():
	next_block_id = randi_range(0, blocks.size() - 1)
	next_block_drawed.emit(blocks[next_block_id]._bundled.names[0])

func _print_locked_segments():
	print("---")
	for i in range(16, 0, -1):
		var line = ""
		for j in range(16):
			var value = "1 " if locked_segments[j][i - 1] != null else "0 "
			line += value
		print(line)
		
func _on_block_locked():
	for segment in current_block.segments:
		var new_segment = locked_segment.instantiate()
		new_segment.set_position_by_idx(segment.pos_x, segment.pos_y)
		locked_segments[segment.pos_x][segment.pos_y] = new_segment
		add_child(new_segment)

	remove_child(current_block)

	_print_locked_segments()
	_remove_locked_segments_if_full_lines()
	while _update_board(): pass

	if _is_board_full():
		board_full.emit()
	else:
		# TODO wyzwalane sygnalem po zakonczeniu animacji	
		_activate_current_block()

func _is_board_full():
	for row in range(14, 16):
		for col in range(5, 11):
			if locked_segments[col][row] != null:
				return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_main_game_paused_change(state):
	if current_block != null:
		current_block.paused = state
