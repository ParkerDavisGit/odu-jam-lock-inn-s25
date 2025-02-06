extends Node2D

class_name ArrayMap

const array_map = preload("res://scenes/TacticalSimulator/array_map.tscn")
const MAPTILE = preload("res://scenes/TacticalSimulator/tile.tscn")

var the_map
var width: int
var height: int

static func create(new_width: int, new_height: int):
	var new_map = array_map.instantiate()
	new_map.width = new_width
	new_map.height = new_height
	
	new_map.resetMap()
	
	var dummy = load("res://scenes/TacticalSimulator/characters/my_dumy_occupant.tscn").instantiate()
	var tile = MAPTILE.MapTile(new_map.get_child(5))
	
	#consolePrint()
	
	return new_map

func resetMap():
	the_map = Array()
	for y in range(self.height):
		for x in range(self.width):
			var temp_tile = MapTile.create(x, y)
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
