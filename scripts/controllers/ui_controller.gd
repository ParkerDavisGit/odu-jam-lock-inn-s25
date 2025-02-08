extends Control

var main_menu
var pause_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu = load("res://scenes/ui/main_menu.tscn").instantiate()
	add_child(main_menu)
