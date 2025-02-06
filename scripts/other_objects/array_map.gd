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
	
	var dummy = load("res://scenes/TacticalSimulator/characters/my_dumy_occupant.tscn")
	
	new_map.get_child(1).setOccupant(dummy.instantiate())
	new_map.get_child(55).setOccupant(dummy.instantiate())
	new_map.get_child(19).setOccupant(dummy.instantiate())
	new_map.get_child(87).setOccupant(dummy.instantiate())
	
	return new_map

func resetMap():
	the_map = Array()
	for y in range(self.height):
		for x in range(self.width):
			var temp_tile = MapTile.create(x, y)
			add_child(temp_tile)
			the_map.append(temp_tile)

func clearHighlights():
	for tile in the_map:
		tile.highlight.visible = false
		tile.lock_highlight = false

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


#####[ Stupid Heatmap Stuff ]##########
func highlightOccupantMovement(tile):
	var distance = tile.occupant.speed
	var heat_map = tilemapToHeatmap(tile.x, tile.y, distance)
	
	for idxy in range(height):
		var s = ""
		for idxx in range(width):
			var c = str(heat_map[width*idxy+idxx])
			s = s + " " + c
			if c.length() < 2:
				s = s + " "
		print(s)
	
	for idy in range(height):
		for idx in range(width):
			if heat_map[width*idy+idx] > 0:
				the_map[width*idy+idx].highlight.visible = true
				the_map[width*idy+idx].lock_highlight = true

func tilemapToHeatmap(x: int, y: int, distance: int):
	var heat_map = Array()
	for idy in range(height):
		for idx in range(width):
			heat_map.append(0)
	
	for idy in range(height):
		for idx in range(width):
			if the_map[width*idy+idx].occupied():
				heat_map[width*idy+idx] = -1

	
	heat_map[width*y+x] = distance + 1
	
	print("Clicked on: ", x,", ", y)
	
	var current_distance = distance + 1
	while current_distance > 1:
		for idy in range(height):
			for idx in range(width):
				if heat_map[width*idy+idx] == current_distance:
					heatMapUpdate(heat_map, idx, idy, current_distance-1)
		current_distance -= 1
	
	
	return heat_map

func heatMapUpdate(heat_map, idx, idy, d):
	var to_test_x = []
	var to_test_y = []
	if idx > 0:
		to_test_x.append(-1)
	if idx < width-1:
		to_test_x.append(1)
	if idy > 0:
		to_test_y.append(-1)
	if idy < height-1:
		to_test_y.append(1)
	
	print(to_test_x)
	print(to_test_y)
	
	print(idx,", ", idy)
	
	for v in to_test_x:
		if heat_map[width*idy+(idx+v)] == 0:
			heat_map[width*idy+(idx+v)] = d
	for v in to_test_y:
		if heat_map[width*(idy+v)+idx] == 0:
			heat_map[width*(idy+v)+idx] = d

# Personal Checklist
func getType() -> String:
	return "arraymap"
