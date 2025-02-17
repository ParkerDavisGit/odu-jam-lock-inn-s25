extends Control

var main_menu
var pause_menu
var piece_selection_menu
var win_screen
var lose_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	pause_menu = load("res://scenes/ui/pause_menu.tscn").instantiate()
	
	add_child(main_menu)
	add_child(pause_menu)
	
	piece_selection_menu = get_child(0)
	win_screen = get_child(2)
	lose_screen = get_child(3)
	
	SignalBus.on_start_editing.connect(_on_start_editing)
	SignalBus.on_open_map.connect(_on_open_map)
	SignalBus.on_load_level.connect(_on_load_level)
	SignalBus.on_open_win_screen.connect(_on_open_win_screen)
	SignalBus.on_open_lose_screen.connect(_on_open_lose_screen)

func _on_load_level(_level):
	get_child(1).visible = false

func _on_open_win_screen():
	win_screen.visible = true
	SignalBus.on_track_play.emit("win")

func _on_open_lose_screen():
	lose_screen.visible = true
	SignalBus.on_track_play.emit("lose")

func _on_open_map():
	get_child(0).visible = false
	get_child(1).openMap()


func _on_start_editing():
	piece_selection_menu.visible = true


func _on_to_hub_pressed() -> void:
	win_screen.visible = false
	lose_screen.visible = false
	SignalBus.on_load_hub.emit()
