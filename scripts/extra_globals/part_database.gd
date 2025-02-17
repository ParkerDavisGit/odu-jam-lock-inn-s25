extends Node

var DB = {}

func _ready():
	add("guard_head_1",  1, 0, 0, 1, 0)
	add("guard_chest_1", 3, 1, 1, 0, 0)
	add("guard_limbs_1", 0, 2, 0, 0, 5)
	
	add("human_head_1",  1, 0, 1, 1, 0)
	add("human_chest_1", 4, 0, 3, 0, 0)
	add("human_limbs_1", 2, 1, 1, 0, 3)
	
	add("angel_head_1",  0, 0, 0, 2, 0)
	add("angel_chest_1", 3, 0, 1, 1, 0)
	add("angel_limbs_1", 0, 0, 0, 1, 4)

func add(the_type, hp, atk, def, mag, mv):
	var temp_part = {}
	temp_part["type"] = the_type
	temp_part["max_health"] = hp
	temp_part["attack"] = atk
	temp_part["defense"] = def
	temp_part["magic"] = mag
	temp_part["move"] = mv
	
	DB[the_type] = temp_part
