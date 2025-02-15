extends Control

var main_menu
var pause_menu
var piece_selection_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	pause_menu = load("res://scenes/ui/pause_menu.tscn").instantiate()
	
	add_child(main_menu)
	add_child(pause_menu)
	
	piece_selection_menu = get_child(0)
	
	SignalBus.on_start_editing.connect(_on_start_editing)


func _on_start_editing(name):
	piece_selection_menu.visible = true
