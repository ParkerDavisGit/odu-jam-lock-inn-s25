extends Node

var music_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player = get_child(0)
	SignalBus.on_track_play.connect(_on_track_play)
	
	SignalBus.on_track_play.emit("test")


func _on_track_play(track_name: String):
	var track = load("res://assets/music/" + track_name + ".mp3")
	music_player.stream = track
	
	await get_tree().create_timer(.5).timeout
	
	music_player.play()
