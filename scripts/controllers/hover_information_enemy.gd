extends Control

var label_hp
var label_mp
var label_atk
var label_def
var label_spd
var label_mv
var label_name
var sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_hp = get_child(1)
	label_mp = get_child(2)
	label_atk = get_child(3)
	label_def = get_child(4)
	label_spd = get_child(5)
	label_mv  = get_child(6)
	sprite = get_child(7)
	label_name = get_child(8)

func loadInfo(occupant):
	if occupant.getType() == "corpse":
		return
	
	var info = occupant.hoverInformation()
	label_hp.text = "HP: " + info["cur_hp"] + "/" + info["max_hp"]
	label_mp.text = "Heal: " + info["heal"]
	label_atk.text = "Attack: " + info["attack"]
	label_mv.text = "Move: " + info["move"]
	
	match occupant.getArchetype():
		"guard":
			label_name.text = "GUARDIAN"
		"human":
			label_name.text = "HUMAN"
		"angel":
			label_name.text = "ANGEL"
	
	
	sprite.texture = occupant.texture

func clear():
	label_hp.text = ""
	label_mp.text = ""
	label_atk.text = ""
	label_def.text = ""
	label_spd.text = ""
	label_mv.text = ""
