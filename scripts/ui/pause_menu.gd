extends Control

func _ready():
	SignalBus.on_pause.connect(_on_pause)
	SignalBus.on_unpause.connect(_on_unpause)
	self.visible = false
	
func _on_pause():
	self.visible = true
	get_child(1).visible = true
	get_child(2).visible = false

func _on_unpause():
	self.visible = false


func closeMainMenu():
	self.visible = false


func _on_pause_level_select_pressed() -> void:
	get_child(1).visible = false
	get_child(2).visible = false


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
	get_child(1).visible = true
	get_child(2).visible = false
