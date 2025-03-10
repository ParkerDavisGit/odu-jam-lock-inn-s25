extends Sprite2D

var max_hp = 5
var cur_hp = max_hp
var max_mp = 0
var cur_mp = max_mp
var attack = 4
var defense = 0
var speed = 0

var heal = 0

var move = 5
var move_left = move

var id

var spent = false

var x
var y

var archetype = "guard"

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
	info["heal"] = str(heal)
	info["attack"] = str(attack)
	info["defense"] = str(defense)
	info["speed"] = str(speed)
	
	info["move"] = str(move)
	info["move_left"] = str(move_left)
	
	return info

func getType():
	return "enemy"

func get_type():
	return "enemy"

func getArchetype():
	return archetype

func getId():
	return id


func healBy(amount):
	cur_hp += amount
	if cur_hp > max_hp:
		cur_hp = max_hp
