extends Node2D

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_quit.connect(_on_quit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("PAUSE"):
		if get_child(0).level == null:
			_on_quit()
		if paused:
			paused = false
			SignalBus.on_unpause.emit()
			return
		
		paused = true
		SignalBus.on_pause.emit()


func _on_quit():
	get_tree().quit()
