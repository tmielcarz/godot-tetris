extends "res://blocks/abstract_block.gd"

func _ready():
	segments.append_array([$SimpleSegment1, $SimpleSegment2, $SimpleSegment3, $SimpleSegment4])
	left_side.append_array([
		[[1, 2], [3, 2]], 
		[[1, 4], [3, 4], [4, 4]],
		[[2, 1], [4, 1]],
		[[1, 3], [2, 3], [4, 3]]
	])
	right_side.append_array([
		[[2, 1], [4, 1]],
		[[1, 3], [2, 3], [4, 3]],
		[[1, 2], [3, 2]],
		[[1, 4], [3, 4], [4, 4]]
	])
	down_side.append_array([
		[[1, 4], [3, 4], [4, 4]], 
		[[2, 1], [4, 1]],
		[[1, 3], [2, 3], [4, 3]],
		[[1, 2], [3, 2]]
	])