extends Node2D

var speed = 50

var left_allowed = true

var right_allowed = true

var down_allowed = true

var rotate_allowed = true

var rotation_1_left = [[1, 2], [4, 2]]
var rotation_1_right = [[3, 1], [4, 1]]
var rotation_1_down = [[1, 4], [2, 4], [4, 4]]
var rotation_1_up = [[1, 3], [2, 3], [3, 3]]

var rotation_direction = 1

signal block_locked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO	
	
	if Input.is_action_just_pressed("move_right") && right_allowed:
		velocity.x += 64
		
	if Input.is_action_just_pressed("move_left") && left_allowed:
		velocity.x -= 64
				
	if Input.is_action_just_pressed("rotate") && rotate_allowed:
		_rotate_block()
		
	if down_allowed:
		if Input.is_action_pressed("move_down"):
			velocity.y += speed * 5 * delta
		else: 
			velocity.y += speed * 1 * delta
		
	position += velocity

func _lock_block():
	left_allowed = false
	right_allowed = false
	down_allowed = false
	rotate_allowed = false
	self.position.y = 64 * round(self.position.y / 64) + 16
	block_locked.emit()
	
func _rotate_block():
	self.rotate(PI / 2)
	rotation_direction += 1
	if rotation_direction == 5:
		rotation_direction = 1

func _on_simple_segment_shape_enter(segment_id, id, collider):
	if rotation_direction == 1:
		for item in rotation_1_left:
			if segment_id == item[0] && id == item[1]:
				left_allowed = false
				
		for item in rotation_1_right:
			if segment_id == item[0] && id == item[1]:
				right_allowed = false
				
		for item in rotation_1_down:
			if segment_id == item[0] && id == item[1]:
				_lock_block()
				

func _on_simple_segment_shape_exit(segment_id, id):
	if rotation_direction == 1:
		for item in rotation_1_left:
			if segment_id == item[0] && id == item[1]:
				left_allowed = true
				
		for item in rotation_1_right:
			if segment_id == item[0] && id == item[1]:
				right_allowed = true

