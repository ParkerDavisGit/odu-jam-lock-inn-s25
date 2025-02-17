extends TextureRect

var label_hp
var label_heal
var label_atk
var label_mv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_hp = get_child(0)
	label_heal = get_child(1)
	label_atk = get_child(2)
	label_mv = get_child(3)

func loadInfo(occupant):
	var info = occupant.hoverInformation()
	label_hp.text = "HP: " + info["cur_hp"] + "/" + info["max_hp"]
	label_heal.text = "Heal: " + info["heal"]
	label_atk.text = "Attack: " + info["attack"]
	label_mv.text = "Move: " + info["move"]
