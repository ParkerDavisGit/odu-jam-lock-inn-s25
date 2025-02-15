extends Node2D

class_name TacticalManager

var uiController
var the_map

var battle_mode
var phase
var control

var selected

var charactersSpent
var charactersAlive
var players
var enemies

var packaged_corpse

## INIT YAY
func create(level_name):
	SignalBus.on_tile_clicked.connect(_on_tile_clicked)
	SignalBus.on_tile_hover.connect(_on_tile_hover)
	
	#the_map = load("res://scenes/TacticalSimulator/array_map.tscn").instantiate()
	the_map = ArrayMap.create(10, 10, level_name)
	add_child(the_map)
	
	uiController = get_child(0)
	
	battle_mode = false
	selected = null
	
	phase = "move"
	control = "player"
	
	charactersSpent = 0
	charactersAlive = 3
	
	SignalBus.on_track_play.emit(level_name)
	SignalBus.on_turn_change.connect(_on_turn_change)
	
	packaged_corpse = load("res://scenes/TacticalSimulator/characters/corpse.tscn")

func drawTheTestZone() -> void:
	for row in the_map:
		for tile in row:
			if tile != 1:
				continue


func attack(tile):
	var damage = selected.occupant.attack
	
	if damage < 0:
		damage = 0
	
	tile.occupant.cur_hp = tile.occupant.cur_hp - damage
	
	if tile.occupant.cur_hp <= 0:
		kill(tile)


func kill(tile: MapTile):
	if tile.occupant.getType() == "player":
		charactersAlive -= 1
	
	elif tile.occupant.getType() == "enemy":
		for i in range(the_map.enemies.size()):
			if the_map.enemies[i].getId() == tile.occupant.getId():
				the_map.enemies.pop_at(i)
				break
	
	#var add_corpse = tile.occupant.getType() == "enemy"
	
	tile.removeOccupant()
	
	#if add_corpse:
	#	tile.setOccupant(packaged_corpse.instantiate())
	
	pass


##### [ YIPPEE ] ######################
func checkTurnCycle():
	charactersSpent += 1
	if charactersSpent >= charactersAlive:
		SignalBus.on_turn_change.emit("enemies")


##### [ SIGNALS ] #####################
func _on_tile_clicked(tile):
	if selected == null:
		if tile.occupied():
			if tile.occupant.getType() != "player":
				return
			if tile.occupant.spent:
				return
			selected = tile
			
			if phase == "attack":
				the_map.highlightAttackTiles(selected)
			else:
				the_map.highlightOccupantMovement(selected)
			#uiController.toggleAbilitySelector()
		
		return
	
	if tile.occupied():
		if selected == null:
			return
		if phase == "attack":
			if tile.attack_highlight.visible:
				attack(tile)
			if tile.defend_highlight.visible:
				tile.occupant.defend = true
			if tile.heal_highlight.visible:
				tile.occupant.healBy(selected.occupant.heal)
			
			print(selected)
			selected.occupant.spend()
			selected = null
			the_map.clearHighlights()
			checkTurnCycle()
			return
		
		#if tile.occupant == selected.occupant:
			#pass
			## THIS IS WHERE DESELECTING HAPPENS
			### NOTICE ME
			#### ALERT
			##### ALERT
			###### ALERT
			####### KEYWORD HERE
		return
	
	if not tile.highlight.visible:
		return
	
	if selected.occupant == null:
		return
	
	var temp = selected.occupant
	selected.occupant.spend()
	selected.removeOccupant()
	tile.setOccupant(temp)
	tile.highlight.visible = true
	the_map.clearHighlights()
	selected = null
	uiController.toggleAbilitySelector()
	checkTurnCycle()
	
	return false

func undefendAll():
	for tile in the_map.the_map:
		if !tile.occupied():
			continue
		if tile.occupant.getType() != "player":
			continue
		if tile.occupant.defend:
			tile.occupant.defend = false

func _on_turn_change(type):
	the_map.playEnemyTurns(phase)
	await get_tree().create_timer(the_map.enemies.size()).timeout
	
	if phase == "attack":
		phase = "move"
		undefendAll()
	else:
		phase = "attack"
	
	the_map.refreshPlayerCharacters()
	charactersSpent = 0

func _on_tile_hover(tile):
	if tile.occupied():
		uiController.loadInfo(tile.occupant)
	else:
		uiController.clear()


func _on_ability_one_pressed() -> void:
	
	
	the_map.highlightAttackTiles(selected)

func _on_ability_one_2_pressed() -> void:
	pass # Replace with function body.

func _on_ability_one_3_pressed() -> void:
	battle_mode = !battle_mode


func clean_up():
	for tile in the_map.the_map:
		tile.queue_free()
