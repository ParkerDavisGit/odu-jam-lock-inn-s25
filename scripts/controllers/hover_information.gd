extends Control

var label_hp
var label_mp
var label_atk
var label_def
var label_spd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_hp = get_child(1)
	label_mp = get_child(2)
	label_atk = get_child(3)
	label_def = get_child(4)
	label_spd = get_child(5)

func loadInfo(occupant):
	var info = occupant.hoverInformation()
	
	label_hp.text = "HP: " + info["cur_hp"] + "/" + info["max_hp"]
	label_mp.text = "MP: " + info["cur_mp"] + "/" + info["max_mp"]
	label_atk.text = "Attack: " + info["attack"]
	label_def.text = "Defense: " + info["defense"]
	label_spd.text = "Speed: " + info["speed"]

func clear():
	label_hp.text = ""
	label_mp.text = ""
	label_atk.text = ""
	label_def.text = ""
	label_spd.text = ""
