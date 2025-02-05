extends Node2D

class_name ArrayMap

const map_tile = preload("res://scenes/TacticalSimulator/tile.tscn")

var the_map
var width: int
var height: int

func _init(new_width: int, new_height: int):
	self.width = new_width
	self.height = new_height
	
	resetMap()
	#consolePrint()

func resetMap():
	the_map = Array()
	for y in range(self.height):
		for x in range(self.width):
			var temp_tile = map_tile.instantiate()
			add_child(temp_tile)
			#the_map.append(temp_tile)
			

###
# Print the contents of the map into the godot console
###
func consolePrint():
	print(get_child(3).toString())
	for y in range(height):
		var s = ""
		for x in range(width):
			s = s + getCharPrintValue(width*y+x)
		print(s)

func getCharPrintValue(idx: int) -> String:
	return the_map[idx].toString()


# Personal Checklist
func getType() -> String:
	return "arraymap"
