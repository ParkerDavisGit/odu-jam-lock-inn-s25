extends TextureButton

var text_body
var text_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_body = get_child(0)
	text_name = get_child(1)
