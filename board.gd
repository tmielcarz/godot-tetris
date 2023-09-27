extends Node2D

@export var locked_segment: PackedScene
@export var l_block_left: PackedScene
@export var z_block_left: PackedScene
@export var i_block: PackedScene

var blocks = []

var current_block

var next_block

var locked_segments = []

signal line_removed

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks.append(l_block_left)
	blocks.append(z_block_left)
	blocks.append(i_block)
	_prepare_locked_segments()
	_create_new_block()

func _prepare_locked_segments():
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
			line_removed.emit()

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

func _print_locked_segments():
	print("---")
	for i in range(16, 0, -1):
		var line = ""
		for j in range(16):
			var value = "1 " if locked_segments[j][i - 1] != null else "0 "
			line += value
		print(line)

func _create_new_block():
	current_block = blocks[randi_range(0, blocks.size() - 1)].instantiate()	
	current_block.position = Vector2(32, -992)
	current_block.connect("block_locked", _on_block_locked)
	add_child(current_block)

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
	# _print_locked_segments()
	
	_create_new_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

