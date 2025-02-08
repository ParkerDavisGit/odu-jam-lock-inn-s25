################################
##====={ My Signals }=========##
################################
extends Node

## For the tilemap
signal on_tile_hover(the_tile)
signal on_tile_clicked(the_tile)

signal on_load_level(level_name)
signal on_unload_level()

signal on_back_to_main_menu()
signal on_quit()
