extends Node2D

class_name MapTile

const map_tile = preload("res://scenes/TacticalSimulator/tile.tscn")

var x: int
var y: int

var occupant


static func create(new_x: int, new_y: int) -> MapTile:
	var new_tile = map_tile.instantiate()
	new_tile.x = new_x
	new_tile.y = new_y
	
	var tile_width = new_tile.get_child(0).size.x
	
	new_tile.position = Vector2(new_x*(tile_width+1)+250, new_y*(tile_width+1)+100)
	
	return new_tile


##### [ OCCUPANT MANAGEMENT ] ######################
func setOccupent(new_occupant):
	occupant = new_occupant

func removeOccupant():
	occupant = null

func getOccupentType():
	if occupant == null:
		return
	
	return occupant.getType()


##### [ STUFF ] ####################
func getType() -> String:
	return occupant.getType()

func toString() -> String:
	return "(%s, %s)" % [str(x), str(y)]
