extends Control

var guard
var human
var angel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guard = load("res://scenes/TacticalSimulator/characters/character.tscn").instantiate()
	human = load("res://scenes/TacticalSimulator/characters/character.tscn").instantiate()
	angel = load("res://scenes/TacticalSimulator/characters/character.tscn").instantiate()
	
	#guard.texture = load("res://assets/dummy.png")
	#human.texture = load("res://assets/dummy.png")
	#angel.texture = load("res://assets/dummy.png")
	
	guard.create("guard")
	human.create("human")
	angel.create("angel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
