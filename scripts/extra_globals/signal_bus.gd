################################
##====={ My Signals }=========##
################################
extends Node

## For the tilemap
@warning_ignore("unused_signal")
signal on_tile_hover(the_tile)
@warning_ignore("unused_signal")
signal on_tile_clicked(the_tile)

@warning_ignore("unused_signal")
signal on_load_level(level_name)
@warning_ignore("unused_signal")
signal on_unload_level()

@warning_ignore("unused_signal")
signal on_pause()
@warning_ignore("unused_signal")
signal on_unpause()

@warning_ignore("unused_signal")
signal on_back_to_main_menu()
@warning_ignore("unused_signal")
signal on_quit()

@warning_ignore("unused_signal")
signal on_track_play(track_name)

@warning_ignore("unused_signal")
signal on_turn_change(type)
@warning_ignore("unused_signal")
signal on_move_occupant(prev_x, prev_y, new_x, new_y)

@warning_ignore("unused_signal")
signal on_attack_phase()
@warning_ignore("unused_signal")
signal on_move_phase()
