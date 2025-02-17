extends Sprite2D

var max_hp = 5
var cur_hp = max_hp
var max_mp = 4
var cur_mp = max_mp
var attack = 3
var defense = 1
var speed = 5

var heal = 1

var move = 6
var move_left = move

var id

var spent = false
var defend = false

var x
var y

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
	
	info["move"] = str(move)
	info["move_left"] = str(move_left)
	
	return info

func getType():
	return "player"

func isHealer():
	return false

func healBy(amount):
	cur_hp += amount
	if cur_hp > max_hp:
		cur_hp = max_hp

func getId():
	return id
