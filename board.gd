extends Node2D

@export var l_block_left: PackedScene
# @export var z_shape_block_1: PackedScene

var blocks = []

var current_block

var next_block

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks.append(l_block_left)
	# blocks.append(z_shape_block_1)
	_create_new_block()

func _create_new_block():
	# current_block = blocks[randi_range(0, 1)].instantiate()
	current_block = l_block_left.instantiate()
	current_block.position = Vector2(592, 32)
	current_block.connect("block_locked", _on_block_locked)
	add_child(current_block)

func _on_block_locked():
	_create_new_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

