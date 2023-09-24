extends Area2D

@export var segment_id = 0

@export var top_enabled = false
@export var right_enabled = false
@export var bottom_enabled = false
@export var left_enabled = false

signal shape_enter(segment_id, id, collider)
signal shape_exit(segment_id, id)

var shape1_enter_signal_sent = false
var shape2_enter_signal_sent = false
var shape3_enter_signal_sent = false
var shape4_enter_signal_sent = false

var shape1_exit_signal_sent = true
var shape2_exit_signal_sent = true
var shape3_exit_signal_sent = true
var shape4_exit_signal_sent = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$ShapeCast2D_1.enabled = right_enabled
	$ShapeCast2D_2.enabled = left_enabled
	$ShapeCast2D_3.enabled = top_enabled
	$ShapeCast2D_4.enabled = bottom_enabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $ShapeCast2D_1.is_colliding() && !shape1_enter_signal_sent:
		shape_enter.emit(segment_id, 1, $ShapeCast2D_1.get_collider(0))
		shape1_enter_signal_sent = true
		shape1_exit_signal_sent = false

	if !$ShapeCast2D_1.is_colliding() && !shape1_exit_signal_sent:
		shape_exit.emit(segment_id, 1)
		shape1_enter_signal_sent = false
		shape1_exit_signal_sent = true

	if $ShapeCast2D_2.is_colliding() && !shape2_enter_signal_sent:
		shape_enter.emit(segment_id, 2, $ShapeCast2D_2.get_collider(0))
		shape2_enter_signal_sent = true
		shape2_exit_signal_sent = false

	if !$ShapeCast2D_2.is_colliding() && !shape2_exit_signal_sent:
		shape_exit.emit(segment_id, 2)
		shape2_enter_signal_sent = false
		shape2_exit_signal_sent = true

	if $ShapeCast2D_3.is_colliding() && !shape3_enter_signal_sent:
		shape_enter.emit(segment_id, 3, $ShapeCast2D_3.get_collider(0))
		shape3_enter_signal_sent = true
		shape3_exit_signal_sent = false
		
	if !$ShapeCast2D_3.is_colliding() && !shape3_exit_signal_sent:
		shape_exit.emit(segment_id, 3)
		shape3_enter_signal_sent = false
		shape3_exit_signal_sent = true

	if $ShapeCast2D_4.is_colliding() && !shape4_enter_signal_sent:
		shape_enter.emit(segment_id, 4, $ShapeCast2D_4.get_collider(0))
		shape4_enter_signal_sent = true
		shape4_exit_signal_sent = false
		
	if !$ShapeCast2D_4.is_colliding() && !shape4_exit_signal_sent:
		shape_exit.emit(segment_id, 4)
		shape4_enter_signal_sent = false
		shape4_exit_signal_sent = true



