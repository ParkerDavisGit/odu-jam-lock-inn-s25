extends Node2D

class_name TacticalManager

const array_map = preload("res://scripts/other_objects/array_map.gd")

var raw_map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raw_map = array_map.new(10, 10)

func drawTheTestZone() -> void:
	for row in raw_map:
		for tile in row:
			if tile != 1:
				continue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
