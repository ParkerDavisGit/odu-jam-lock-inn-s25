extends Node2D

class_name MapTile

const map_tile = preload("res://scenes/TacticalSimulator/tile.tscn")

var x: int
var y: int

var occupant
var is_occupied

var texture
var highlight
var attack_highlight

var lock_highlight
var unmoveable

##### [ CONSTRUCTOR ] #################
static func create(new_x: int, new_y: int, type: String) -> MapTile:
	var new_tile = map_tile.instantiate()
	new_tile.x = new_x
	new_tile.y = new_y
	
	var tile_width = new_tile.get_child(0).texture_normal.get_width()
	new_tile.position = Vector2(new_x*(tile_width+1)+250, new_y*(tile_width+1)+100)
	
	new_tile.texture = new_tile.get_child(0)
	new_tile.highlight = new_tile.get_child(1)
	new_tile.attack_highlight = new_tile.get_child(2)
	
	new_tile.highlight.visible = false
	new_tile.attack_highlight.visible = false
	
	new_tile.lock_highlight = false

	new_tile.is_occupied = false
	
	assignTextures(new_tile, type)
	
	return new_tile

static func assignTextures(new_tile, short_type):
	var type = "MISSING"
	var high_type = "MISSING_highlight"
	new_tile.unmoveable = true
	
	match short_type:
		"tre":
			type = "tree"
		"grs":
			type = "grass"
			high_type = "grass_highlight"
			new_tile.unmoveable = false
	
	new_tile.texture.texture_normal = load("res://assets/%s.png" % type)
	new_tile.highlight.texture = load("res://assets/%s.png" % high_type)
	

##### [ OCCUPANTS ] ###################
func setOccupant(new_occupant):
	occupant = new_occupant
	is_occupied = true
	occupant.x = x
	occupant.y = y
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


func addAttackHighlight():
	attack_highlight.visible = true

func removeAttackHighlight():
	attack_highlight.visible = false


##### [ SIGNALS ] #####################
func _on_tile_button_mouse_entered() -> void:
	SignalBus.on_tile_hover.emit(self)
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

func _on_tile_button_pressed() -> void:
	if unmoveable:
		return
	
	SignalBus.on_tile_clicked.emit(self)

##### [ STUFF ] #######################
func getType() -> String:
	return occupant.getType()

func toString() -> String:
	return "(%s, %s) - %s" % [str(x), str(y), self.occupant]
