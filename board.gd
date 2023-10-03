extends Node2D

@export var locked_segment: PackedScene
@export var l_block_left: PackedScene
@export var z_block_left: PackedScene
@export var i_block: PackedScene

var blocks = {}

var current_speed

var current_block

var next_block_id

var locked_segments

signal line_removed

signal next_block_drawed(block_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks[0] = l_block_left
	blocks[1] = z_block_left
	blocks[2] = i_block

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

func _insert_locked_segments(segment):
	var x = int((segment.position.x + 480) / 64)
	var y = -int((segment.position.y + 32) / 64)
	locked_segments[x][y] = segment

func _check_locked_segments():
	for i in range(16):
		var count = 0
		for j in range(16):
			var value = 1 if locked_segments[j][i] != null else 0
			count += value
		if count == 16:
			_remove_filled_line(i)
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

func _remove_filled_line(line):
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

func _on_block_locked():
	for segment in current_block.segments:
		var new_segment = locked_segment.instantiate()
		var diff_position = segment.global_position - current_block.global_position
		new_segment.position = current_block.position + diff_position
		_insert_locked_segments(new_segment)
		add_child(new_segment)

	remove_child(current_block)
	
	_check_locked_segments()
	while _update_board(): pass

	# TODO wyzwalane sygnalem po zakonczeniu animacji
	_activate_current_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_main_game_paused_change(state):
	if current_block != null:
		current_block.paused = state
