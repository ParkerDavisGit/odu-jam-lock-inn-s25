extends Node

var the_grid
var width: int
var height: int

var players: Array
var enemies: Array

var character_controller

func create(new_width: int, new_height: int, level_name: String, cc):
	self.width = new_width
	self.height = new_height
	
	the_grid = []
	for y in range(new_height):
		var temp = []
		for x in range(new_width):
			temp.append(null)
		the_grid.append(temp)

	
	return self

func tile_get(x: int, y: int):
	return the_grid[y][x]


func set_at(x: int, y: int, tile: MapTile):
	the_grid[y][x] = tile



func dbg():
	for y in range(self.height):
		var s = ""
		for x in range(self.width):
			if the_grid[y][x].unmoveable:
				s = s + " X "
			else:
				s = s + "   "
		
		print(s)
