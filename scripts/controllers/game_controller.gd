extends Node2D

var packaged_tactical_level
var packaged_hub_controller

var mode
var paused
var level = null
var hub = null

var in_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	packaged_tactical_level = load("res://scenes/controllers/tactical_manager.tscn")
	packaged_hub_controller = load("res://scenes/controllers/hub_controller.tscn")
	
	SignalBus.on_load_level.connect(_on_load_level)
	SignalBus.on_back_to_main_menu.connect(_on_back_to_main_menu)
	SignalBus.on_load_hub.connect(_on_load_hub)

func _on_load_level(level_name):
	if level != null:
		level.queue_free()
		level = null
	
	in_game = true
	if hub != null:
		remove_child(hub)
		hub.queue_free()
	
	level = packaged_tactical_level.instantiate()
	level.create(level_name, get_parent().get_child(3))
	add_child(level)

func _on_load_hub():
	if hub != null:
		hub.queue_free()
		hub = null
	
	if level != null:
		level.queue_free()
		level = null
	
	SignalBus.on_track_play.emit("hub")
	
	in_game = true
	hub = packaged_hub_controller.instantiate()
	add_child(hub)

func _on_back_to_main_menu():
	remove_child(level)
	level = null
