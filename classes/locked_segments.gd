extends Object
class_name LockedSegments

var locked_segments

func prepare():
	locked_segments = []
	for i in range(16):
		locked_segments.append([])
		for j in range(16):
			locked_segments[i].append([])
			locked_segments[i][j] = null

func is_full():
	for row in range(14, 16):
		for col in range(5, 11):
			if locked_segments[col][row] != null:
				return true
	return false

func update():
	for row in range(16):
		var count = 0
		for col in range(16):
			var value = 1 if locked_segments[col][row] == null else 0
			count += value
		if count == 16:
			return _move_down(row)

	return false

func remove_full_line():
	for i in range(16):
		var line = []
		for j in range(16):
			if locked_segments[j][i] != null:
				line.append(locked_segments[j][i])
		if line.size() == 16:
			for k in range(16):
				set_segment(k, i, null)
			return line
	return []

func set_segment(x, y, value):
	locked_segments[x][y] = value
	
func _move_down(line):
	var found = false
	for row in range(line + 1, 16):
		for col in range(16):
			locked_segments[col][row - 1] = locked_segments[col][row]
			if locked_segments[col][row - 1] != null:
				locked_segments[col][row - 1].position.y += 64
				found = true

	for col in range(16):
		locked_segments[col][15] = null
		
	return found

func print():
	print("---")
	for i in range(16, 0, -1):
		var line = ""
		for j in range(16):
			var value = "1 " if locked_segments[j][i - 1] != null else "0 "
			line += value
		print(line)
