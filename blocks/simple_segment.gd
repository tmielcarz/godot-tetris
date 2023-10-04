extends Area2D

@export var top_enabled = false
@export var right_enabled = false
@export var bottom_enabled = false
@export var left_enabled = false

var pos_x = 0
var pos_y = 0

var shapes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	shapes.append_array([$ShapeCast2D_0, $ShapeCast2D_1, $ShapeCast2D_2, $ShapeCast2D_3, $ShapeCast2D_4])
	$ShapeCast2D_0.enabled = true
	$ShapeCast2D_1.enabled = right_enabled
	$ShapeCast2D_2.enabled = left_enabled
	$ShapeCast2D_3.enabled = top_enabled
	$ShapeCast2D_4.enabled = bottom_enabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var diff_position = self.global_position - get_parent().global_position
	var segment_position = get_parent().position + diff_position
	pos_x = int(segment_position.x + 32) / 64 + 7
	pos_y = int(segment_position.y) / 64 * -1
			




