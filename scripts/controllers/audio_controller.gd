extends Node

var music_player: AudioStreamPlayer
var sound_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player = get_child(0)
	sound_player = get_child(1)
	
	SignalBus.on_track_play.connect(_on_track_play)
	SignalBus.on_sound_play.connect(_on_sound_play)
	
	SignalBus.on_track_play.emit("menu")


func _on_sound_play(sound_name: String):
	var track = load("res://assets/sfx/" + sound_name + ".mp3")
	sound_player.stream = track
	sound_player.play()


func _on_track_play(track_name: String):
	#print(track_name)
	var track = load("res://assets/music/" + track_name + ".mp3")
	music_player.stream = track
	
	await get_tree().create_timer(.25).timeout
	
	music_player.play()
