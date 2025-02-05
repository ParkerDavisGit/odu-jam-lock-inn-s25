extends Node2D

class_name MapTile

var x: int
var y: int

var occupent

func _init(new_x: int, new_y: int):
	x = new_x
	y = new_y

func setOccupent(new_occupent):
	occupent = new_occupent

func getOccupentType():
	return occupent.getType()


#####[ STUFF ]####################
func getType() -> String:
	return occupent.getType()

func toString() -> String:
	return "(%s, %s)" % [str(x), str(y)]
