extends Node2D

var packaged_tactical_level

var mode
var paused
var level = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	packaged_tactical_level = load("res://scenes/controllers/tactical_manager.tscn")
	
	SignalBus.on_load_level.connect(_on_load_level)
	SignalBus.on_back_to_main_menu.connect(_on_back_to_main_menu)

func _on_load_level(level_name):
	if level != null:
		level.queue_free()
		level = null
	
	level = packaged_tactical_level.instantiate()
	level.create(level_name)
	add_child(level)

func _on_back_to_main_menu():
	remove_child(level)
	level = null
