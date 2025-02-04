class_name ArrayMap

var the_map
var width: int
var height: int

func _init(new_width: int, new_height: int):
	self.width = new_width
	self.height = new_height
	
	resetMap()
	consolePrint()

func resetMap():
	the_map = Array()
	for row in range(height):
		for col in range(width):
			the_map.append("X")

###
# Print the contents of the map into the godot console
###
func consolePrint():
	for row in range(height):
		var s = ""
		for col in range(width):
			s = s + getCharPrintValue(5*row+col-1)
		print(s)

func getCharPrintValue(idx: int) -> String:
	return the_map[idx]


# Personal Checklist
func getType() -> String:
	return "arraymap"
