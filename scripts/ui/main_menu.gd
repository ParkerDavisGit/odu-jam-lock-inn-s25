extends Control

func _ready():
	SignalBus.on_back_to_main_menu.connect(_on_back_to_main_menu)
	
func _on_back_to_main_menu():
	self.visible = true
	get_child(0).visible = true
	get_child(1).visible = false


func closeMainMenu():
	self.visible = false


func _on_to_level_select_pressed() -> void:
	get_child(0).visible = false
	get_child(1).visible = true


func _on_quitgame_pressed() -> void:
	SignalBus.on_quit.emit()

func _on_one_pressed() -> void:
	SignalBus.on_load_level.emit("1")
	closeMainMenu()

func _on_two_pressed() -> void:
	SignalBus.on_load_level.emit("2")
	closeMainMenu()


func _on_three_pressed() -> void:
	SignalBus.on_load_level.emit("3")
	closeMainMenu()


func _on_default_pressed() -> void:
	SignalBus.on_load_level.emit("default")
	closeMainMenu()


func _on_level_back_pressed() -> void:
	get_child(0).visible = true
	get_child(1).visible = false


func _on_button_pressed() -> void:
	SignalBus.on_start_editing.emit("guard")


func _on_button_2_pressed() -> void:
	SignalBus.on_start_editing.emit("human")


func _on_button_3_pressed() -> void:
	SignalBus.on_start_editing.emit("angel")
