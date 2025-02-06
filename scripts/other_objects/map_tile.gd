extends Node2D

class_name MapTile

const map_tile = preload("res://scenes/TacticalSimulator/tile.tscn")

var x: int
var y: int

var occupant
var is_occupied
var highlight
var lock_highlight

##### [ CONSTRUCTOR ] #################
static func create(new_x: int, new_y: int) -> MapTile:
	var new_tile = map_tile.instantiate()
	new_tile.x = new_x
	new_tile.y = new_y
	
	var tile_width = new_tile.get_child(0).texture_normal.get_width()
	new_tile.position = Vector2(new_x*(tile_width+1)+250, new_y*(tile_width+1)+100)
	
	new_tile.highlight = new_tile.get_child(1)
	new_tile.highlight.visible = false
	new_tile.lock_highlight = false

	new_tile.is_occupied = false
	
	return new_tile


##### [ OCCUPANTS ] ###################
func setOccupant(new_occupant):
	occupant = new_occupant
	is_occupied = true
	add_child(occupant)
	
func removeOccupant():
	remove_child(occupant)
	is_occupied = false
	occupant = null

func getOccupentType():
	if occupant == null:
		return
	
	return occupant.getType()

func occupied() -> bool:
	return is_occupied


##### [ SIGNALS ] #####################
func _on_tile_button_mouse_entered() -> void:
	if not occupied():
		return
	if highlight.visible:
		return
	highlight.visible = true
	
func _on_tile_button_mouse_exited() -> void:
	if lock_highlight == true:
		return
	
	if highlight.visible:
		highlight.visible = false
		print("off!")

func _on_tile_button_pressed() -> void:
	SignalBus.on_tile_clicked.emit(self)

##### [ STUFF ] #######################
func getType() -> String:
	return occupant.getType()

func toString() -> String:
	return "(%s, %s)" % [str(x), str(y)]
