extends "res://blocks/abstract_block.gd"

func _ready():
	segments.append_array([$SimpleSegment1, $SimpleSegment2, $SimpleSegment3, $SimpleSegment4])
	sides.append_array([
		[[1, 2], [4, 2]], 
		[[3, 4], [4, 4]],
		[[2, 1], [3, 1]],
		[[1, 3], [2, 3]],
	])
