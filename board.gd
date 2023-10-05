extends Node2D

@export var locked_segment: PackedScene
@export var l_block_left: PackedScene
@export var l_block_right: PackedScene
@export var z_block_left: PackedScene
@export var z_block_right: PackedScene
@export var i_block: PackedScene
@export var t_block: PackedScene
@export var square_block: PackedScene

var ls = LockedSegments.new()

var blocks = {}

var current_speed

var current_block

var next_block_id

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
	ls.prepare()
	current_speed = 50
	_draw_next_block()
	_activate_current_block()

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
		new_segment.set_position_by_idx(segment.pos_x, segment.pos_y)
		ls.set_segment(segment.pos_x, segment.pos_y, new_segment)
		add_child(new_segment)

	remove_child(current_block)

	ls.print()
	
	var line_to_remove = ls.remove_full_line()
	while line_to_remove.size() > 0:
		for segment in line_to_remove:
			remove_child(segment)
			
		line_removed.emit()
		current_speed += 10			
		line_to_remove = ls.remove_full_line()
	
	while ls.update(): pass

	if ls.is_full():
		board_full.emit()
	else:
		# TODO wyzwalane sygnalem po zakonczeniu animacji	
		_activate_current_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_main_game_paused_change(state):
	if current_block != null:
		current_block.paused = state
