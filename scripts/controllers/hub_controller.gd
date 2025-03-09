extends Node2D

var text_box
var camera: Camera2D

var in_dialogue = false

var zooming = false
var zooming_dir = "in"
var zoom_to_x
var zoom_to_y
var zoom_to_s = 1.25

var zoom_d_x = 800
var zoom_d_y = 450
var zoom_d_s = 1

var zoom_t = 2
var zoom_elapsed = 0

var dialogue
var dia_idx

var cur_dia = "intro"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_child(5)
	text_box = camera.get_child(0)
	loadHubData()
	
	Flags.intro_monologue = true
	if !Flags.intro_monologue:
		loadDialogue("intro_monologue", "???")
	Flags.intro_monologue = true

func _process(delta) -> void:
	#if zooming:
		##A * (1 - t) + B * t
	'''if zooming_dir == "in":
		var new_zoom = zoom_d_s * (1-zoom_elapsed/zoom_t) + zoom_to_s * zoom_elapsed/zoom_t
		var new_x = zoom_d_x * (1-zoom_elapsed/zoom_t) + zoom_to_x * zoom_elapsed/zoom_t
		var new_y = zoom_d_y * (1-zoom_elapsed/zoom_t) + zoom_to_y * zoom_elapsed/zoom_t
		camera.zoom.x = new_zoom
		camera.zoom.y = new_zoom
		camera.position.x = new_x
		camera.position.y = new_y
		zoom_elapsed += delta
	
	if zoom_elapsed >= zoom_t:
		if zooming_dir == "out":
			camera.x = zoom_d_x
			camera.y = zoom_d_y
			camera.zoom = Vector2(1, 1)
			zooming_dir = "in"
		elif zooming_dir == "in":
			camera.position.x = zoom_to_x
			camera.position.y = zoom_to_y
			camera.zoom =  Vector2(zoom_to_s, zoom_to_s)
			zooming_dir = "out"
		zooming = false'''
	
	if !in_dialogue:
		return
	
	if Input.is_action_just_pressed("ProgressDialogue"):
		incrementDialogue()

func loadHubData():
	pass

func zoom(x, y, z):
	camera.zoom 

func getSpeaker(speaker):
	match speaker:
		"g1":
			return "The Unfaithful"
		"g2":
			return "The Banished"
		"g3":
			return "The Exiled"
	
	return speaker

func loadDialogue(filename, speaker):
	var path = "res://data/dialogue/" + filename + ".txt"
	var raw_data = FileAccess.open(path, FileAccess.READ)
	var data = Array(raw_data.get_as_text().split("\n"))
	data.pop_back()
	
	dialogue = data
	dia_idx = 0
	
	in_dialogue = true
	text_box.visible = true
	text_box.text_name.text = getSpeaker(speaker)
	
	incrementDialogue()
	
	match speaker:
		"g1":
			return "Ghost Uno"
		"g2":
			return "Ghost Dos"
		"g3":
			return "Ghost Tres"

func incrementDialogue():
	if dia_idx >= dialogue.size():
		if cur_dia == "intro":
			cur_dia = "unfaithful"
			loadDialogue("intro_unfaithful", "The Unfaithful")
			return
		elif cur_dia == "unfaithful":
			cur_dia = "traitor"
			loadDialogue("intro_traitor", "The Traitor")
			return
		elif cur_dia == "traitor":
			cur_dia = "exiled"
			loadDialogue("intro_exiled", "The Exiled")
			return
		
		
		text_box.visible = false
		in_dialogue = false
		return
	
	text_box.text_body.text = dialogue[dia_idx]
	
	dia_idx += 1


func _on_npc_ghost_1_pressed() -> void:
	
	if in_dialogue:
		return
	
	var dia_lvl = Flags.g1_dia_level
	var filename = ""
	
	if dia_lvl == "none":
		return
	
	Flags.g1_dia_level = "none"
	
	filename = "g1_" + dia_lvl
	
	loadDialogue(filename, "g1")


func _on_npc_ghost_2_pressed() -> void:
	if in_dialogue:
		return
	
	var dia_lvl = Flags.g2_dia_level
	var filename = ""
	
	if dia_lvl == "none":
		return
	
	Flags.g2_dia_level = "none"
	
	filename = "g2_" + dia_lvl
	
	loadDialogue(filename, "g2")


func _on_npc_ghost_3_pressed() -> void:
	if in_dialogue:
		return
	
	var dia_lvl = Flags.g3_dia_level
	var filename = ""
	
	if dia_lvl == "none":
		return
	
	Flags.g3_dia_level = "none"
	
	filename = "g3_" + dia_lvl
	
	loadDialogue(filename, "g3")


func _on_progress_dialogue():
	if !in_dialogue:
		return


func _on_map_pressed() -> void:
	if in_dialogue:
		return
	SignalBus.on_sound_play.emit("button")
	SignalBus.on_open_map.emit()


func _on_ghost_editor_pressed() -> void:
	SignalBus.on_sound_play.emit("button")
	SignalBus.on_start_editing.emit()
