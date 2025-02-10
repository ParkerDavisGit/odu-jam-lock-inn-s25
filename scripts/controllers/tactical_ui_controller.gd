extends Control

var hover_info
var ability_selector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hover_info = get_child(0)
	ability_selector = get_child(1)

func loadInfo(occupant):
	hover_info.loadInfo(occupant)

func clear():
	hover_info.clear()

func toggleAbilitySelector():
	ability_selector.visible = !ability_selector.visible
