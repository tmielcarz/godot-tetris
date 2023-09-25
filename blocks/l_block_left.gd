extends Node2D

var speed = 50

var locked = false

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

var segments = []

signal block_locked

# Called when the node enters the scene tree for the first time.
func _ready():
	segments.append_array([$SimpleSegment1, $SimpleSegment2, $SimpleSegment3, $SimpleSegment4])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !locked:
		var velocity = Vector2.ZERO
		
		var actual_speed = speed
		
		if Input.is_action_just_pressed("move_right") && _is_right_allowed():
			velocity.x += 64
			
		if Input.is_action_just_pressed("move_left") && _is_left_allowed():
			velocity.x -= 64
					
		if Input.is_action_just_pressed("rotate"):
			_try_rotate_block()
			
		if Input.is_action_pressed("move_down"):
			actual_speed = 5 * speed
			
		if _is_down_allowed():
			velocity.y += actual_speed * delta
		else:
			_lock_block()
			
		position += velocity

func _lock_block():
	locked = true
	self.position.y = 64 * round(self.position.y / 64) + 16
	block_locked.emit()
	
func _is_rotation_valid():
	for segment in segments:
		segment.shapes[0].force_shapecast_update()
		if segment.shapes[0].is_colliding():
			return false
	return true
	
func _try_rotate_block():
	self.rotate(PI / 2)
	
	if _is_rotation_valid():
		rotation_direction += 1
		if rotation_direction == 4:
			rotation_direction = 0
	else:
		print("rotation reverted")
		self.rotate(-PI / 2)
		

func _is_allowed(segments_def):
	for segment_def in segments_def:
		var segment_id = segment_def[0]
		var shape_id = segment_def[1]
		if segments[segment_id - 1].shapes[shape_id].is_colliding():
			return false
	return true	

func _is_left_allowed():
	return _is_allowed(left_side[rotation_direction])

func _is_right_allowed():
	return _is_allowed(right_side[rotation_direction])
	
func _is_down_allowed():
	return _is_allowed(down_side[rotation_direction])	
