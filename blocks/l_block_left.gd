extends Node2D

var speed = 50

var locked = false

var left_allowed = true

var right_allowed = true

var rotate_allowed = true

var left_side = [
	[[1, 2], [4, 2]], 
	[[1, 4], [2, 4], [4, 4]],
	[[3, 1], [4, 1]],
	[[1, 3], [2, 3], [3, 3]],
]
var right_side = [
	[[3, 1], [4, 1]], 
	[[1, 3], [2, 3], [3, 3]],
	[[1, 2], [4, 2]],
	[[1, 4], [2, 4], [4, 4]]
]
var down_side = [
	[[1, 4], [2, 4], [4, 4]], 
	[[3, 1], [4, 1]],
	[[1, 3], [2, 3], [3, 3]],
	[[1, 2], [4, 2]]
]

var rotation_direction = 0

signal block_locked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !locked:
		var velocity = Vector2.ZERO	
		
		if Input.is_action_just_pressed("move_right") && right_allowed:
			velocity.x += 64
			
		if Input.is_action_just_pressed("move_left") && left_allowed:
			velocity.x -= 64
					
		if Input.is_action_just_pressed("rotate") && rotate_allowed:
			_rotate_block()
			
		if Input.is_action_pressed("move_down"):
			velocity.y += speed * 5 * delta
		else: 
			velocity.y += speed * 1 * delta
			
		position += velocity

func _lock_block():
	locked = true
	self.position.y = 64 * round(self.position.y / 64) + 16
	block_locked.emit()
	
func _rotate_block():
	self.rotate(PI / 2)
	rotation_direction += 1
	if rotation_direction == 4:
		rotation_direction = 0

func _check_shape(array, segment_id, side_id):
	for item in array:
		if segment_id == item[0] && side_id == item[1]:
			return true
	return false

func _on_simple_segment_shape_enter(segment_id, id, _collider):
	if _check_shape(left_side[rotation_direction], segment_id, id): left_allowed = false
	if _check_shape(right_side[rotation_direction], segment_id, id): right_allowed = false
	if _check_shape(down_side[rotation_direction], segment_id, id): _lock_block()

func _on_simple_segment_shape_exit(segment_id, id):
	if _check_shape(left_side[rotation_direction], segment_id, id): left_allowed = true
	if _check_shape(right_side[rotation_direction], segment_id, id): right_allowed = true
