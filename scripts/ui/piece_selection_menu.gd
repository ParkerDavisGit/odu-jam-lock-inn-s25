extends Control

var preview_head
var preview_chest
var preview_limbs

var textures = {}

var gc = load("res://assets/pieces/guard_chest_1.png")
var hc = load("res://assets/pieces/human_chest_1.png")
var ac = load("res://assets/pieces/angel_chest_1.png")

var gl = load("res://assets/pieces/guard_limbs_1.png")
var hl = load("res://assets/pieces/human_limbs_1.png")
var al = load("res://assets/pieces/angel_limbs_1.png")

var selected = null

var cc = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preview_head = get_child(0)
	preview_chest = get_child(1)
	preview_limbs = get_child(2)
	
	SignalBus.on_part_change.connect(_on_part_change)
	SignalBus.on_start_editing.connect(_on_start_editing)
	
	var t_h = {}
	t_h["angel1"] = load("res://assets/pieces/angel_head_1.png")
	t_h["human1"] = load("res://assets/pieces/human_head_1.png")
	t_h["guard1"] = load("res://assets/pieces/guard_head_1.png")
	
	var t_c = {}
	t_c["angel1"] = load("res://assets/pieces/angel_chest_1.png")
	t_c["human1"] = load("res://assets/pieces/human_chest_1.png")
	t_c["guard1"] = load("res://assets/pieces/guard_chest_1.png")
	
	var t_l = {}
	t_l["angel1"] = load("res://assets/pieces/angel_limbs_1.png")
	t_l["human1"] = load("res://assets/pieces/human_limbs_1.png")
	t_l["guard1"] = load("res://assets/pieces/guard_limbs_1.png")
	
	textures["head"] = t_h
	textures["chest"] = t_c
	textures["limbs"] = t_l
	
	visible = false
	
	SignalBus.on_connect_character_controller.connect(_on_connect_character_controller)


func _on_connect_character_controller(the_cc):
	cc = the_cc


func _on_start_editing(name):
	match name:
		"guard":
			selected = cc.guard
		"human":
			selected = cc.human
		"angel":
			selected = cc.angel
	
	selected.changing_pieces = true



func _on_part_change(species, part, tier):
	match part:
		"head":
			preview_head.texture = textures["head"][species + tier]
		"chest":
			preview_chest.texture = textures["chest"][species + tier]
		"limbs":
			preview_limbs.texture = textures["limbs"][species + tier]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ah_one_pressed() -> void:
	SignalBus.on_part_change.emit("angel", "head", "1")


func _on_hl_one_pressed() -> void:
	SignalBus.on_part_change.emit("human", "limbs", "1")


func _on_gl_one_pressed() -> void:
	SignalBus.on_part_change.emit("guard", "limbs", "1")


func _on_al_one_pressed() -> void:
	SignalBus.on_part_change.emit("angel", "limbs", "1")


func _on_hc_one_pressed() -> void:
	SignalBus.on_part_change.emit("human", "chest", "1")


func _on_gc_one_pressed() -> void:
	SignalBus.on_part_change.emit("guard", "chest", "1")


func _on_ac_one_pressed() -> void:
	SignalBus.on_part_change.emit("angel", "chest", "1")


func _on_hh_one_pressed() -> void:
	SignalBus.on_part_change.emit("human", "head", "1")


func _on_gh_one_pressed() -> void:
	SignalBus.on_part_change.emit("guard", "head", "1")


func _on_save_pressed() -> void:
	selected.changing_pieces = false
	visible = false
