extends Node

var DB = {}

func _ready():
	add("head_guard_1",  0, 0, 0, 1, 0)
	add("chest_guard_1", 5, 0, 1, 0, 0)
	add("limbs_guard_1", 0, 3, 0, 0, 5)
	
	add("head_human_1",  0, 0, 0, 1, 0)
	add("chest_human_1", 7, 0, 3, 0, 0)
	add("limbs_human_1", 0, 2, 0, 0, 4)
	
	add("head_angel_1",  0, 0, 0, 3, 0)
	add("chest_angel_1", 5, 0, 1, 0, 0)
	add("limbs_angel_1", 0, 1, 0, 0, 3)

func add(the_type, hp, atk, def, mag, mv):
	var temp_part = {}
	temp_part["type"] = the_type
	temp_part["max_health"] = hp
	temp_part["attack"] = atk
	temp_part["defense"] = def
	temp_part["magic"] = mag
	temp_part["move"] = mv
	
	DB[the_type] = temp_part
