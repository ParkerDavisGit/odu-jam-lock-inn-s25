extends Node2D

class_name Interactable

var type: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type = "default"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func interact() -> void:
	@warning_ignore("assert_always_true")
	assert(false, "YOU FORGOT TO OVERWRITE INTERACT() IN %s YOU IDIOT" % type)
