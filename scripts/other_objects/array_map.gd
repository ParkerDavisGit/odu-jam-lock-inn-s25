extends Node2D

class_name ArrayMap

const array_map = preload("res://scenes/TacticalSimulator/array_map.tscn")
const MAPTILE = preload("res://scenes/TacticalSimulator/tile.tscn")

var the_map
var width: int
var height: int

static func create(new_width: int, new_height: int, level_name: String):
	var new_map = array_map.instantiate()
	var map_data = readMapData(level_name)
	var char_data = readCharData(level_name)
	
	new_map.width = new_width
	new_map.height = new_height
	
	new_map.resetMap(new_width, map_data)
	populateMap(new_map, char_data)
	
	return new_map

static func readCharData(level_name):
	var data = FileAccess.open("res://data/level_data/%s.txt" % (level_name+"_char"), FileAccess.READ)
	data = data.get_as_text()
	data = data.split("\n")
	data = data.slice(0, data.size()-1)
	return data

static func populateMap(map, data):
	var dummy = load("res://scenes/TacticalSimulator/characters/my_dumy_occupant.tscn")
	var dummy_enemy = load("res://scenes/TacticalSimulator/characters/my_dummy_enemy.tscn")
	
	var line = ""
	var idx = 0
	for raw_line in data:
		line = raw_line.split(" ")
		idx = map.width*int(line[2]) + int(line[1])
		match line[0]:
			"ch1":
				map.get_child(idx).setOccupant(dummy.instantiate())
			"ch2":
				map.get_child(idx).setOccupant(dummy.instantiate())
			"ch3":
				map.get_child(idx).setOccupant(dummy.instantiate())
			"en1":
				map.get_child(idx).setOccupant(dummy_enemy.instantiate())


static func readMapData(level_name):
	var data = FileAccess.open("res://data/level_data/%s.txt" % level_name, FileAccess.READ)
	data = data.get_as_text()
	data = data.split("\n")
	
	var s = ""
	for str in data:
		s = s + str
	
	data = s
	data = data.split(",")
	data = data.slice(0, data.size()-1)
	
	return data

func resetMap(width, data):
	the_map = Array()
	for y in range(self.height):
		for x in range(self.width):
			var temp_tile = MapTile.create(x, y, data[width*y+x])
			temp_tile.name = "(%s, %s)" % [str(x), str(y)]
			add_child(temp_tile)
			the_map.append(temp_tile)

func clearHighlights():
	for tile in the_map:
		tile.highlight.visible = false
		tile.attack_highlight.visible = false
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
		#print(s)
	
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
				continue
			if the_map[width*idy+idx].unmoveable:
				heat_map[width*idy+idx] = -1

	
	heat_map[width*y+x] = distance + 1
	
	#print("Clicked on: ", x,", ", y)
	
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
	
	
	for v in to_test_x:
		if heat_map[width*idy+(idx+v)] == 0:
			heat_map[width*idy+(idx+v)] = d
	for v in to_test_y:
		if heat_map[width*(idy+v)+idx] == 0:
			heat_map[width*(idy+v)+idx] = d


func highlightAttackTiles(selected):
	var idx = width * selected.y + selected.x
	var given_x = selected.x
	var given_y = selected.y
	
	var idx_up = idx - width
	var idx_left = idx - 1
	var idx_right = idx + 1
	var idx_down = idx + width
	
	### This is some of the worst code I have written in a while ;-;
	if given_x < width - 1:
		if the_map[idx_right].occupied():
			if the_map[idx_right].occupant.getType() == "enemy":
				the_map[idx_right].addAttackHighlight()
	if given_x > 0:
		if the_map[idx_left].occupied():
			if the_map[idx_left].occupant.getType() == "enemy":
				the_map[idx_left].addAttackHighlight()
	if given_y < height - 1:
		if the_map[idx_down].occupied():
			if the_map[idx_down].occupant.getType() == "enemy":
				the_map[idx_down].addAttackHighlight()
	if given_y > 0:
		if the_map[idx_up].occupied():
			if the_map[idx_up].occupant.getType() == "enemy":
				the_map[idx_up].addAttackHighlight()

func refreshPlayerCharacters():
	for tile in the_map:
		if not tile.occupied():
			continue
		if tile.occupant.getType() == "player":
			tile.occupant.unspend()

### ALERT
### TODO
### Func for getting idx's for surrounding tiles

# Personal Checklist
func getType() -> String:
	return "arraymap"
