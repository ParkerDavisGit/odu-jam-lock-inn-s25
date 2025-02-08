extends Control

var hover_info

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hover_info = get_child(0)

func loadInfo(occupant):
	hover_info.loadInfo(occupant)

func clear():
	hover_info.clear()
