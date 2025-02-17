extends Control

var hover_info
var hover_info_enemy
var ability_selector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hover_info = get_child(0)
	ability_selector = get_child(1)
	hover_info_enemy = get_child(2)

func loadInfo(occupant):
	if occupant.getType() == "player":
		hover_info.loadInfo(occupant)
	else:
		#print("Why?")
		hover_info_enemy.loadInfo(occupant)

func clear():
	hover_info.clear()

func toggleAbilitySelector():
	#ability_selector.visible = !ability_selector.visible
	pass
