extends Sprite2D

var max_hp = randi() % 5 + 1
var cur_hp = randi() % 5 + 1
var max_mp = randi() % 5 + 1
var cur_mp = randi() % 5 + 1
var attack = randi() % 5 + 1
var defense = randi() % 5 + 1
var speed = randi() % 5 + 1

func _ready():
	if cur_hp > max_hp:
		cur_hp = max_hp
	if cur_mp > max_mp:
		cur_mp = max_mp

func hoverInformation():
	var info = {}
	info["max_hp"] = str(max_hp)
	info["cur_hp"] = str(cur_hp)
	info["max_mp"] = str(max_mp)
	info["cur_mp"] = str(cur_mp)
	info["attack"] = str(attack)
	info["defense"] = str(defense)
	info["speed"] = str(speed)
	
	return info
