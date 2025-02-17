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

var char_1
var char_2
var char_3

var hover_info

var selected = null

var cc = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preview_head = get_child(1)
	preview_chest = get_child(2)
	preview_limbs = get_child(3)
	
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
	
	char_1 = get_child(14)
	char_2 = get_child(15)
	char_3 = get_child(16)
	
	hover_info = get_child(17)
	
	visible = false
	
	SignalBus.on_connect_character_controller.connect(_on_connect_character_controller)


func _on_connect_character_controller(the_cc):
	cc = the_cc
	await get_tree().create_timer(.5).timeout
	char_1.add_child(cc.guard.clone())
	char_2.add_child(cc.human.clone())
	char_3.add_child(cc.angel.clone())
	
	selected = char_1
	
	var head_type = selected.get_child(0).pieces["head"].type.split("_")[0]
	var chest_type = selected.get_child(0).pieces["chest"].type.split("_")[0]
	var limbs_type = selected.get_child(0).pieces["limbs"].type.split("_")[0]
	preview_head.texture = textures["head"][head_type + "1"]
	preview_chest.texture = textures["chest"][chest_type + "1"]
	preview_limbs.texture = textures["limbs"][limbs_type + "1"]
	
	hover_info.loadInfo(selected.get_child(0))


func _on_start_editing(name):
	match name:
		"guard":
			selected = cc.guard
		"human":
			selected = cc.human
		"angel":
			selected = cc.angel
	
	selected.changing_pieces = true
	


func _on_part_change(species, part, tier, changing_name):
	match part:
		"head":
			preview_head.texture = textures["head"][species + tier]
		"chest":
			preview_chest.texture = textures["chest"][species + tier]
		"limbs":
			preview_limbs.texture = textures["limbs"][species + tier]
	
	await get_tree().create_timer(.1).timeout
	
	hover_info.loadInfo(selected.get_child(0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ah_one_pressed() -> void:
	SignalBus.on_part_change.emit("angel", "head", "1", selected.get_child(0).char_name)


func _on_hl_one_pressed() -> void:
	SignalBus.on_part_change.emit("human", "limbs", "1", selected.get_child(0).char_name)


func _on_gl_one_pressed() -> void:
	SignalBus.on_part_change.emit("guard", "limbs", "1", selected.get_child(0).char_name)


func _on_al_one_pressed() -> void:
	SignalBus.on_part_change.emit("angel", "limbs", "1", selected.get_child(0).char_name)


func _on_hc_one_pressed() -> void:
	SignalBus.on_part_change.emit("human", "chest", "1", selected.get_child(0).char_name)


func _on_gc_one_pressed() -> void:
	SignalBus.on_part_change.emit("guard", "chest", "1", selected.get_child(0).char_name)


func _on_ac_one_pressed() -> void:
	SignalBus.on_part_change.emit("angel", "chest", "1", selected.get_child(0).char_name)


func _on_hh_one_pressed() -> void:
	SignalBus.on_part_change.emit("human", "head", "1", selected.get_child(0).char_name)


func _on_gh_one_pressed() -> void:
	SignalBus.on_part_change.emit("guard", "head", "1", selected.get_child(0).char_name)


func _on_save_pressed() -> void:
	visible = false
	SignalBus.on_sound_play.emit("button")


func _on_swap_to_one_pressed() -> void:
	selected = char_1
	
	var head_type = selected.get_child(0).pieces["head"].type.split("_")[0]
	var chest_type = selected.get_child(0).pieces["chest"].type.split("_")[0]
	var limbs_type = selected.get_child(0).pieces["limbs"].type.split("_")[0]
	preview_head.texture = textures["head"][head_type + "1"]
	preview_chest.texture = textures["chest"][chest_type + "1"]
	preview_limbs.texture = textures["limbs"][limbs_type + "1"]


func _on_swap_to_two_pressed() -> void:
	selected = char_2
	
	var head_type = selected.get_child(0).pieces["head"].type.split("_")[0]
	var chest_type = selected.get_child(0).pieces["chest"].type.split("_")[0]
	var limbs_type = selected.get_child(0).pieces["limbs"].type.split("_")[0]
	preview_head.texture = textures["head"][head_type + "1"]
	preview_chest.texture = textures["chest"][chest_type + "1"]
	preview_limbs.texture = textures["limbs"][limbs_type + "1"]


func _on_swap_to_three_pressed() -> void:
	selected = char_3
	
	var head_type = selected.get_child(0).pieces["head"].type.split("_")[0]
	var chest_type = selected.get_child(0).pieces["chest"].type.split("_")[0]
	var limbs_type = selected.get_child(0).pieces["limbs"].type.split("_")[0]
	preview_head.texture = textures["head"][head_type + "1"]
	preview_chest.texture = textures["chest"][chest_type + "1"]
	preview_limbs.texture = textures["limbs"][limbs_type + "1"]
