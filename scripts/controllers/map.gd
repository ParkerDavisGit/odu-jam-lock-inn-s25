extends Control

var guard_one
var human_one
var angel_one

var guard_two
var human_two
var angel_two

var guard_area
var human_area
var angel_area

var in_guard = false
var in_human = false
var in_angel = false


func _ready():
	guard_one = get_child(1)
	human_one = get_child(2)
	angel_one = get_child(3)
	
	guard_two = get_child(4)
	human_two = get_child(5)
	angel_two = get_child(6)
	
	#guard_area = get_child(9)
	#human_area = get_child(7)
	#angel_area = get_child(8)
	

func openMap():
	visible = true
	
	if Flags.level_clear_guard_2:
		guard_two.texture_normal = load("res://assets/map_icon_cleared.png")
		guard_two.cleared = true
		guard_two.clickable = false
	elif Flags.level_clear_guard_1:
		guard_one.texture_normal = load("res://assets/map_icon_cleared.png")
		guard_two.texture_normal = load("res://assets/map_icon_clickable.png")
		guard_one.cleared = true
		
		guard_two.clickable = true
		guard_one.clickable = false
	else:
		guard_one.texture_normal = load("res://assets/map_icon_clickable.png")
		guard_two.texture_normal = load("res://assets/map_icon_out_of_reach.png")
		
		guard_one.clickable = true
	
	if Flags.level_clear_human_2:
		human_two.texture_normal = load("res://assets/map_icon_cleared.png")
		human_two.cleared = true
		human_two.clickable = false
	elif Flags.level_clear_human_1:
		human_one.texture_normal = load("res://assets/map_icon_cleared.png")
		human_two.texture_normal = load("res://assets/map_icon_clickable.png")
		human_one.cleared = true
		
		human_two.clickable = true
		human_one.clickable = false
	else:
		human_one.texture_normal = load("res://assets/map_icon_clickable.png")
		human_two.texture_normal = load("res://assets/map_icon_out_of_reach.png")
		
		human_one.clickable = true
	
	if Flags.level_clear_angel_2:
		angel_two.texture_normal = load("res://assets/map_icon_cleared.png")
		angel_two.cleared = true
		angel_two.clickable = false
	elif Flags.level_clear_angel_1:
		angel_one.texture_normal = load("res://assets/map_icon_cleared.png")
		angel_two.texture_normal = load("res://assets/map_icon_clickable.png")
		angel_one.cleared = true
		
		angel_two.clickable = true
		angel_one.clickable = false
	else:
		angel_one.texture_normal = load("res://assets/map_icon_clickable.png")
		angel_two.texture_normal = load("res://assets/map_icon_out_of_reach.png")
		
		angel_one.clickable = true
	


func _on_human_one_pressed() -> void:
	if !human_one.clickable:
		return
	
	SignalBus.on_load_level.emit("human_level_1")


func _on_angel_one_pressed() -> void:
	if !angel_one.clickable:
		return
	
	SignalBus.on_load_level.emit("angel_level_1")


func _on_guard_one_pressed() -> void:
	if !guard_one.clickable:
		return
	
	SignalBus.on_load_level.emit("guard_level_1")


func _on_guard_two_pressed() -> void:
	if !guard_two.clickable:
		return
	
	SignalBus.on_load_level.emit("guard_level_2")


func _on_human_two_pressed() -> void:
	if !human_two.clickable:
		return
	
	SignalBus.on_load_level.emit("human_level_2")


func _on_angel_two_pressed() -> void:
	if !angel_two.clickable:
		return
	
	SignalBus.on_load_level.emit("angel_level_2")



func _on_human_area_mouse_entered() -> void:
	if !visible:
		return
	
	if in_human:
		return
	#print("Human")
	SignalBus.on_track_play.emit("human_hover")
	in_guard = false
	in_human = true
	in_angel = false


func _on_angel_area_mouse_entered() -> void:
	if !visible:
		return
	
	if in_angel:
		return
	
	#print("Angel")
	SignalBus.on_track_play.emit("angel_hover")
	in_guard = false
	in_human = false
	in_angel = true


func _on_guard_area_mouse_entered() -> void:
	if !visible:
		return
	
	if in_guard:
		return
	
	#print("Guard")
	SignalBus.on_track_play.emit("guard_hover")
	in_guard = true
	in_human = false
	in_angel = false
