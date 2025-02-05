extends Node2D

class_name TacticalManager

var raw_map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raw_map = ArrayMap.create(10, 10)
	add_child(raw_map)

func drawTheTestZone() -> void:
	for row in raw_map:
		for tile in row:
			if tile != 1:
				continue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
