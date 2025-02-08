extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_quit.connect(_on_quit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("QUIT"):
		if get_child(0).level == null:
			_on_quit()
		SignalBus.on_back_to_main_menu.emit()


func _on_quit():
	get_tree().quit()
