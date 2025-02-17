extends Sprite2D

var packaged_self

var max_hp = 0
var cur_hp = 0
var max_mp = 0
var cur_mp = 0
var attack = 0
var defense = 0
var speed = 0

var heal = 0

var move = 0
var move_left = move

var id

var spent = false
var defend = false

var temp_one
var temp_two
var temp_three

var changing_pieces = false
var pieces = {}
var piece_children = {}

var x
var y

var char_name

func create(new_name):
	var temp_package = load("res://scenes/TacticalSimulator/characters/part.tscn")
	packaged_self = load("res://scenes/TacticalSimulator/characters/character.tscn")
	
	char_name = new_name
	
	temp_one = temp_package.instantiate()
	temp_two = temp_package.instantiate()
	temp_three = temp_package.instantiate()
	
	add_child(temp_one)
	add_child(temp_two)
	add_child(temp_three)
	
	pieces["head"] = temp_one
	pieces["chest"] = temp_two
	pieces["limbs"] = temp_three
	
	piece_children["head"] = get_child(0)
	piece_children["chest"] = get_child(1)
	piece_children["limbs"] = get_child(2)
	
	addPart("head", "guard_head_1")
	addPart("chest", "guard_chest_1")
	addPart("limbs", "guard_limbs_1")
	
	SignalBus.on_part_change.connect(_on_part_change)
	


func _on_part_change(species, part, tier, changing_name):
	if changing_name != char_name:
		return
	
	var part_name = species + "_" + part + "_" + tier
	addPart(part, part_name)

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
	info["heal"] = str(heal)
	
	info["move"] = str(move)
	info["move_left"] = str(move_left)
	
	return info

func getType():
	return "player"

func isHealer():
	return heal > 1

func healBy(amount):
	cur_hp += amount
	if cur_hp > max_hp:
		cur_hp = max_hp

func getId():
	return id


func addPart(location, piece):
	if pieces[location].type != "":
		removePart(location)
	
	var temp = PartDatabase.DB[piece]
	
	pieces[location].reset(temp["type"], temp["max_health"], temp["attack"], temp["defense"], temp["magic"], 0, temp["move"])
	##hp, atk, def, mag, spd, mv
	
	max_hp += temp["max_health"]
	cur_hp = max_hp
	attack += temp["attack"]
	defense += temp["defense"]
	heal += temp["magic"]
	move += temp["move"]
	
	piece_children[location].texture = load("res://assets/pieces/" + temp["type"] + ".png")

func removePart(location):
	var temp = pieces[location]
	
	max_hp -= temp.max_hp_mod
	cur_hp = max_hp
	attack -= temp.attack_mod
	defense -= temp.defense_mod
	heal -= temp.magic_mod
	move -= temp.move_mod
	
	pieces[location].reset("", 0, 0, 0, 0, 0, 0)

func clone():
	var temp = packaged_self.instantiate()
	temp.create(char_name)
	
	temp.addPart("head", pieces["head"].type)
	temp.addPart("chest", pieces["chest"].type)
	temp.addPart("limbs", pieces["limbs"].type)
	
	return temp
