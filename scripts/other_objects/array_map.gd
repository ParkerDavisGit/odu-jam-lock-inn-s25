extends Node2D

class_name ArrayMap

const array_map = preload("res://scenes/TacticalSimulator/array_map.tscn")
const tile_grid = preload("res://scenes/TacticalSimulator/tile_grid.tscn")
const MAPTILE = preload("res://scenes/TacticalSimulator/tile.tscn")

var the_map
var the_grid
var width: int
var height: int

var players: Array
var enemies: Array

var character_controller

static func create(new_width: int, new_height: int, level_name: String, cc):
	var new_map = array_map.instantiate()
	var map_data = readMapData(level_name)
	var char_data = readCharData(level_name) 
	
	new_map.the_grid = tile_grid.instantiate().create(new_width, new_height, level_name, cc)
	
	new_map.width = new_width
	new_map.height = new_height
	
	new_map.players = []
	new_map.enemies = []
	
	new_map.character_controller = cc
	#print(cc.human)
	
	new_map.resetMap(map_data)
	populateMap(new_map, char_data, cc)
	
	new_map.the_grid.dbg()
	
	return new_map

static func readCharData(level_name):
	var data = FileAccess.open("res://data/level_data/%s.txt" % (level_name+"_char"), FileAccess.READ)
	data = data.get_as_text()
	data = data.split("\n")
	data = data.slice(0, data.size()-1)
	return data

static func populateMap(map, data, cc):
	var dummy = load("res://scenes/TacticalSimulator/characters/my_dumy_occupant.tscn")
	var dummy_enemy = load("res://scenes/TacticalSimulator/characters/my_dummy_enemy.tscn")
	
	var guard = load("res://scenes/TacticalSimulator/characters/enemies/enemy_guard.tscn")
	var human = load("res://scenes/TacticalSimulator/characters/enemies/enemy_human.tscn")
	var angel = load("res://scenes/TacticalSimulator/characters/enemies/enemy_angel.tscn")
	
	var currentId = 0
	var line = ""
	var idx = 0
	for raw_line in data:
		line = raw_line.split(" ")
		idx = map.width*int(line[2]) + int(line[1])
		match line[0]:
			"ch1":
				var temp = cc.guard.clone()
				temp.id = currentId
				map.get_child(idx).setOccupant(temp)
				map.players.append(temp)
			"ch2":
				var temp = cc.human.clone()
				temp.id = currentId
				map.get_child(idx).setOccupant(temp)
				map.players.append(temp)
			"ch3":
				var temp = cc.angel.clone()
				temp.id = currentId
				map.get_child(idx).setOccupant(temp)
				map.players.append(temp)
			"guard":
				var temp = guard.instantiate()
				temp.id = currentId
				map.get_child(idx).setOccupant(temp)
				map.enemies.append(temp)
			"human":
				var temp = human.instantiate()
				temp.id = currentId
				map.get_child(idx).setOccupant(temp)
				map.enemies.append(temp)
			"angel":
				var temp = angel.instantiate()
				temp.id = currentId
				map.get_child(idx).setOccupant(temp)
				map.enemies.append(temp)
		
		currentId += 1



static func readMapData(level_name):
	var data = FileAccess.open("res://data/level_data/%s.txt" % level_name, FileAccess.READ)
	data = data.get_as_text()
	data = data.split("\n")
	
	var s = ""
	for st in data:
		s = s + st
	
	data = s
	data = data.split(",")
	data = data.slice(0, data.size()-1)
	
	return data

func resetMap(data):
	the_map = Array()
	for y in range(self.height):
		for x in range(self.width):
			var temp_tile = MapTile.create(x, y, data[width*y+x])
			temp_tile.name = "(%s, %s)" % [str(x), str(y)]
			add_child(temp_tile)
			the_map.append(temp_tile)
			the_grid.set_at(x, y, temp_tile)

func clearHighlights():
	the_grid.clear_highlights()

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
	var distance = tile.occupant.move
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
			if self.the_grid.is_occupied(idx, idy):
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
	var occupant_type: String = ""
	
	### GET RIGHT
	occupant_type = self.the_grid.get_occupant_type(selected.x + 1, selected.y)
	if occupant_type == "enemy":
		self.the_grid.add_highlight(selected.x + 1, selected.y, "attack")
	elif occupant_type == "player":
		self.the_grid.add_highlight(selected.x + 1, selected.y, "heal")
	
	### GET LEFT
	occupant_type = self.the_grid.get_occupant_type(selected.x - 1, selected.y)
	if occupant_type == "enemy":
		self.the_grid.add_highlight(selected.x - 1, selected.y, "attack")
	elif occupant_type == "player":
		self.the_grid.add_highlight(selected.x - 1, selected.y, "heal")
	
	### GET DOWN
	occupant_type = self.the_grid.get_occupant_type(selected.x, selected.y + 1)
	if occupant_type == "enemy":
		self.the_grid.add_highlight(selected.x, selected.y + 1, "attack")
	elif occupant_type == "player":
		self.the_grid.add_highlight(selected.x, selected.y + 1, "heal")
	
	### GET UP
	occupant_type = self.the_grid.get_occupant_type(selected.x, selected.y - 1)
	if occupant_type == "enemy":
		self.the_grid.add_highlight(selected.x, selected.y - 1, "attack")
	elif occupant_type == "player":
		self.the_grid.add_highlight(selected.x, selected.y - 1, "heal")
	
	self.the_grid.add_highlight(selected.x, selected.y, "defend")

func refreshPlayerCharacters():
	the_grid.refresh_player_characters()


func enemyHeatmap(start_x, start_y, enemy):
	var heat_map = Array()
	for idy in range(height):
		for idx in range(width):
			heat_map.append(0)
	
	for idy in range(height):
		for idx in range(width):
			if the_grid.is_occupied(idx, idy):
				if the_grid.get_occupant(idx, idy).getId() != enemy.getId():
					heat_map[width*idy+idx] = -2
					continue
			if the_grid.get_tile(idx, idy).unmoveable:
				heat_map[width*idy+idx] = -1

	var val = 0
	heat_map[width*start_y+start_x] = val + 1
	
	var current_value = val + 1
	while current_value < 20:
		for idy in range(height):
			for idx in range(width):
				if heat_map[width*idy+idx] == current_value:
					enemyHeatMapUpdate(heat_map, idx, idy, current_value+1)
		current_value += 1
	
	return heat_map


func enemyHeatMapUpdate(heat_map, idx, idy, d):
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
		elif heat_map[width*idy+(idx+v)] == -2:
			heat_map[width*idy+(idx+v)] = -d
	for v in to_test_y:
		if heat_map[width*(idy+v)+idx] == 0:
			heat_map[width*(idy+v)+idx] = d
		elif heat_map[width*(idy+v)+idx] == -2:
			heat_map[width*(idy+v)+idx] = -d

func enemyAttack(enemy):
	var x = enemy.x
	var y = enemy.y
	
	var potential_targets = []
	if the_grid.get_occupant_type(x-1, y) == "player":
		potential_targets.append(the_grid.get_occupant(x-1, y))
	
	if the_grid.get_occupant_type(x+1, y) == "player":
		potential_targets.append(the_grid.get_occupant(x+1, y))
	
	if the_grid.get_occupant_type(x, y-1) == "player":
		potential_targets.append(the_grid.get_occupant(x, y-1))
	
	if the_grid.get_occupant_type(x, y+1) == "player":
		potential_targets.append(the_grid.get_occupant(x, y+1))
	
	var best_target = null
	
	if enemy.getArchetype() == "angel":
		var lowest_health_percent = 1
		var temp
		if the_map[width*y+(x+1)].getType() == "enemy":
			temp = the_map[width*y+(x+1)].occupant.cur_hp / the_map[width*y+(x+1)].occupant.max_hp
			if temp < lowest_health_percent:
				best_target = the_map[width*y+(x+1)].occupant
		
		if the_map[width*y+(x-1)].getType() == "enemy":
			temp = the_map[width*y+(x-1)].occupant.cur_hp / the_map[width*y+(x-1)].occupant.max_hp
			if temp < lowest_health_percent:
				best_target = the_map[width*y+(x-1)].occupant
			
		if the_map[width*(y-1)+x].getType() == "enemy":
			temp = the_map[width*(y-1)+x].occupant.cur_hp / the_map[width*(y-1)+x].occupant.max_hp
			if temp < lowest_health_percent:
				best_target = the_map[width*(y-1)+x].occupant
				
		if the_map[width*(y+1)+x].getType() == "enemy":
			temp = the_map[width*(y+1)+x].occupant.cur_hp / the_map[width*(y+1)+x].occupant.max_hp
			if temp < lowest_health_percent:
				best_target = the_map[width*(y+1)+x].occupant
		
		if best_target == null:
			await get_tree().create_timer(.5).timeout
			return
		
		best_target.healBy(enemy.heal)
		SignalBus.on_sound_play.emit("heal")
		
		the_grid.get_tile(best_target.x, best_target.y).heal_highlight.visible = true
		
		await get_tree().create_timer(.5).timeout
		return
	
	var found_healer = false
	for target in potential_targets:
		if enemy.getArchetype() == "guard":
			if best_target == null:
				best_target = target
				continue
			
			if target.cur_hp < best_target.cur_hp:
				best_target = target
				continue
			continue
		
		elif enemy.getArchetype() == "human":
			if found_healer:
				## Need to select closest healer, but that's for later
				continue
			
			if target.isHealer():
				best_target = target
				found_healer = true
			
			else:
				if best_target == null:
					best_target = target
					continue
	
	
	## This SHOULD only run for humans who aren't next to a healer
	if best_target == null:
		if potential_targets.size() > 0:
			best_target = potential_targets[0]
		
		else:
			await get_tree().create_timer(.5).timeout
			return
	
	if best_target == null:
		await get_tree().create_timer(.5).timeout
		return
	
	the_map[width*best_target.y+best_target.x].attack_highlight.visible = true
	if best_target.defend:
		if enemy.attack < best_target.defense:
			await get_tree().create_timer(.5).timeout
			return
		else:
			best_target.cur_hp = best_target.cur_hp - enemy.attack + best_target.defense
			if best_target.cur_hp <= 0:
				get_parent().kill(best_target.get_parent())
			await get_tree().create_timer(.5).timeout
			return
	
	
	best_target.cur_hp = best_target.cur_hp - enemy.attack
	SignalBus.on_sound_play.emit("attack")
	
	if best_target.cur_hp <= 0:
		get_parent().kill(best_target.get_parent())
	await get_tree().create_timer(.5).timeout

func playEnemyTurns(phase):
	for enemy in enemies:
		if phase == "attack":
			enemyAttack(enemy)
			await get_tree().create_timer(1).timeout
			the_grid.clear_highlights()
			continue
		
		await get_tree().create_timer(.5).timeout
		
		var heat_map = enemyHeatmap(enemy.x, enemy.y, enemy)
		
		if enemy.getArchetype() == "angel":
			for idxy in range(height):
				var s = ""
				for idxx in range(width):
					var c = str(heat_map[width*idxy+idxx])
					s = s + c + " "
				print(s)
		## Get list of player's heatmap values
		var target_values = []
		var target_coords = []
		var coords_to_test = []
		var found_healer = false
		var healer_values = []
		var healer_coords = []
		var healer_coords_to_test = []
		if enemy.getArchetype() != "angel":
			for player in players:
				target_values.append(heat_map[width*player.y+player.x])
				target_coords.append(player.x)
				target_coords.append(player.y)
				if player.isHealer():
					healer_values.append(heat_map[width*player.y+player.x])
					healer_coords.append(player.x)
					healer_coords.append(player.y)
					found_healer = true
					if player.x > 0:
						healer_coords_to_test.append(player.x-1)
						healer_coords_to_test.append(player.y)
					if player.x < width-1:
						healer_coords_to_test.append(player.x+1)
						healer_coords_to_test.append(player.y)
					if player.y > 0:
						healer_coords_to_test.append(player.x)
						healer_coords_to_test.append(player.y-1)
					if player.y < height-1:
						healer_coords_to_test.append(player.x)
						healer_coords_to_test.append(player.y+1)
				if player.x > 0:
					coords_to_test.append(player.x-1)
					coords_to_test.append(player.y)
				if player.x < width-1:
					coords_to_test.append(player.x+1)
					coords_to_test.append(player.y)
				if player.y > 0:
					coords_to_test.append(player.x)
					coords_to_test.append(player.y-1)
				if player.y < height-1:
					coords_to_test.append(player.x)
					coords_to_test.append(player.y+1)
		else:
			for player in enemies:
				if (player.getId() == enemy.getId()):
					continue
				if player.getArchetype() == "angel":
					continue
				target_values.append(heat_map[width*player.y+player.x])
				target_coords.append(player.x)
				target_coords.append(player.y)
				if player.x > 0:
					coords_to_test.append(player.x-1)
					coords_to_test.append(player.y)
				if player.x < width-1:
					coords_to_test.append(player.x+1)
					coords_to_test.append(player.y)
				if player.y > 0:
					coords_to_test.append(player.x)
					coords_to_test.append(player.y-1)
				if player.y < height-1:
					coords_to_test.append(player.x)
					coords_to_test.append(player.y+1)
		
		
		var smallest_idx = 0
		var smallest_tile_value = 999
		var found_healer_coords = false
		if found_healer:
			for i in range(healer_coords_to_test.size() / 2):
				if heat_map[width*healer_coords_to_test[i*2+1]+healer_coords_to_test[i*2]] > 0:
					if heat_map[width*healer_coords_to_test[i*2+1]+healer_coords_to_test[i*2]] < smallest_tile_value:
						if heat_map[width*healer_coords_to_test[i*2+1]+healer_coords_to_test[i*2]] > 0:
							smallest_tile_value = heat_map[width*healer_coords_to_test[i*2+1]+healer_coords_to_test[i*2]]
							smallest_idx = i
							found_healer_coords = true
			if smallest_tile_value == 999:
				for i in range(coords_to_test.size() / 2):
					if heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]] > 0:
						if heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]] < smallest_tile_value:
							if heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]] > 0:
								smallest_tile_value = heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]]
								smallest_idx = i
		else:
			for i in range(coords_to_test.size() / 2):
				if heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]] > 0:
					if heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]] < smallest_tile_value:
						if heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]] > 0:
							smallest_tile_value = heat_map[width*coords_to_test[i*2+1]+coords_to_test[i*2]]
							smallest_idx = i
		
		
		#if minimum_space[0] == 100 or minimum_space[0] > enemy.move+1:
		if smallest_tile_value > 100:
			continue
		if found_healer_coords:
			if heat_map[width*healer_coords_to_test[smallest_idx*2+1]+healer_coords_to_test[smallest_idx*2]] > enemy.move:
				var goal = enemy.move+1
				var closest_x = 100
				var closest_y = 100
				var closest_d = 10000
				var goal_x = healer_coords_to_test[smallest_idx*2]
				var goal_y = healer_coords_to_test[smallest_idx*2+1]
				
				for y in range(height):
					for x in range(width):
						if heat_map[width*y+x] != goal:
							continue
						
						var d = pow(goal_x - x, 2) + pow(goal_y - y, 2)
						if d < closest_d:
							closest_x = x
							closest_y = y
							closest_d = d
				
				if closest_d > 9999:
					continue
				
				the_grid.get_tile(enemy.x, enemy.y).removeOccupant()
				the_grid.get_tile(closest_x, closest_y).setOccupant(enemy)
				
				continue
			
			
		if heat_map[width*coords_to_test[smallest_idx*2+1]+coords_to_test[smallest_idx*2]] > enemy.move:
			var goal = enemy.move+1
			var closest_x = 100
			var closest_y = 100
			var closest_d = 10000
			var goal_x = coords_to_test[smallest_idx*2]
			var goal_y = coords_to_test[smallest_idx*2+1]
			
			for y in range(height):
				for x in range(width):
					if heat_map[width*y+x] != goal:
						continue
					
					var d = pow(goal_x - x, 2) + pow(goal_y - y, 2)
					if d < closest_d:
						closest_x = x
						closest_y = y
						closest_d = d
			
			if closest_d > 9999:
				continue
			
			the_grid.get_tile(enemy.x, enemy.y).removeOccupant()
			the_grid.get_tile(closest_x, closest_y).setOccupant(enemy)
			
			continue

		the_grid.get_tile(enemy.x, enemy.y).removeOccupant()
		the_grid.get_tile(coords_to_test[smallest_idx*2], coords_to_test[smallest_idx*2+1]).setOccupant(enemy)
		
	phase = "attack"



### ALERT
### TODO
### Func for getting idx's for surrounding tiles

# Personal Checklist
func getType() -> String:
	return "arraymap"
