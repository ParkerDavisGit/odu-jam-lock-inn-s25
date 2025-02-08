extends Node2D

class_name TacticalManager

var uiController
var the_map

var selected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_tile_clicked.connect(_on_tile_clicked)
	SignalBus.on_tile_hover.connect(_on_tile_hover)
	
	the_map = ArrayMap.create(10, 10, "3")
	add_child(the_map)
	
	uiController = get_child(0)

	selected = null

func drawTheTestZone() -> void:
	for row in the_map:
		for tile in row:
			if tile != 1:
				continue


##### [ SIGNALS ] #####################
func _on_tile_clicked(tile):
	if selected == null:
		if tile.occupied():
			selected = tile
			the_map.highlightOccupantMovement(selected)
		
		return
	
	if tile.occupied():
		return
	
	if not tile.highlight.visible:
		return
	
	var temp = selected.occupant
	selected.removeOccupant()
	tile.setOccupant(temp)
	tile.highlight.visible = true
	the_map.clearHighlights()
	selected = null

func _on_tile_hover(tile):
	if tile.occupied():
		uiController.loadInfo(tile.occupant)
	else:
		uiController.clear()
