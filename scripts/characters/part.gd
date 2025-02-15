extends Sprite2D

var max_hp_mod = 0
var attack_mod = 0
var defense_mod = 0
var magic_mod = 0 
var speed_mod = 0
var move_mod = 0

var type = ""


func reset(the_type, hp, atk, def, mag, spd, mv):
	type = the_type
	
	max_hp_mod = hp
	attack_mod = atk
	defense_mod = def
	magic_mod = mag
	speed_mod = spd
	move_mod = mv
