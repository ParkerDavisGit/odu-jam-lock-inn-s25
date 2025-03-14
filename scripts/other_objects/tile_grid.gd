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

### ACCESSORS ###
func get_tile(x: int, y: int):
	return the_grid[y][x]
func tile(x: int, y: int):
	return the_grid[y][x]

func is_occupied(x: int, y: int) -> bool:
	return the_grid[y][x].occupied()

func get_occupant(x: int, y: int):
	## Out of bounds check
	if x < 0 or x > width-1 or y < 0 or y > height-1:
		return null
	
	## Occupant exists check
	if !the_grid[y][x].occupied():
		return null
	
	## Return
	return the_grid[y][x].occupant

func get_occupant_type(x: int, y: int) -> String:
	var occupant = self.get_occupant(x, y)
	
	if occupant == null:
		return ""
	
	return occupant.get_type()

### MUTATORS ###
func set_at(x: int, y: int, tile: MapTile):
	the_grid[y][x] = tile

func add_highlight(x: int, y: int, type: String):
	var tile = self.tile(x, y)
	
	match type:
		"attack":
			tile.addAttackHighlight()
		"heal":
			tile.addHealHighlight()
		"defend":
			tile.addDefendHighlight()

func clear_highlights():
	for row in the_grid:
		for tile in row:
			tile.highlight.visible = false
			tile.removeHighlights()
			tile.lock_highlight = false

func refresh_player_characters():
	for row in the_grid:
		for tile in row:
			if not tile.occupied():
				continue
			if tile.occupant.get_type() == "player":
				tile.occupant.unspend()


func dbg():
	for y in range(self.height):
		var s = ""
		for x in range(self.width):
			if the_grid[y][x].unmoveable:
				s = s + " X "
			else:
				s = s + "   "
		
		print(s)
