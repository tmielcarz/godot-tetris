extends Node2D

@export var locked_segment: PackedScene
@export var l_block_left: PackedScene
@export var z_block_left: PackedScene
@export var i_block: PackedScene

var blocks = []

var current_block

var next_block

var locked_segments = []

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
			locked_segments[i][j] = 0

func _insert_locked_segments(segment_position):
	var x = int((segment_position.x + 480) / 64)
	var y = -int((segment_position.y + 32) / 64)
	locked_segments[x][y] = 1
	
func _check_locked_segments():
	for i in range(16):
		var count = 0
		for j in range(16):
			count += locked_segments[j][i]
		if count == 16:
			print("Line " + str(i) + " is full")

func _print_locked_segments():
	print("---")
	for i in range(16, 0, -1):
		var line = ""
		for j in range(16):
			line += str(locked_segments[j][i - 1]) + " "
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
		_insert_locked_segments(new_segment.position)
		add_child(new_segment)

	_print_locked_segments()
	_check_locked_segments()

	remove_child(current_block)
	
	_create_new_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

