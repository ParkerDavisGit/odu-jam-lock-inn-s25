extends Sprite2D

var max_hp = randi() % 5 + 1
var cur_hp = max_hp
var max_mp = randi() % 5 + 1
var cur_mp = randi() % 5 + 1
var attack = randi() % 5 + 1
var defense = randi() % 5 + 1
var speed = randi() % 5 + 1

var spent = false

func _ready():
	pass

func spend():
	spent = true
	self.modulate.a = 0.5

func unspend():
	spent = false
	self.modulate.a = 1


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

func getType():
	return "enemy"
